app.controller "HomeCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$routeParams'
  '$mdMedia'
  '$mdToast'
  'scheduleService'
  'appService'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $rp,$mdMedia,$mdToast,scheduleService,appService) ->
    $scope.accountId = $scope.userSession.id

    # console.log $scope.userSession.id
    $http.get 'employee/myteam/'+ $scope.accountId,cache:true
    .success (data) ->
      if data
        # console.log data
        $scope.myteams = data
      else
        console.log 'error man'

    $scope.selectedTeam = (team) ->
      # console.log team
      $scope.enableToSchedule = false
      $scope.teamName = team.teamId.name
      $scope.teamId =  team.teamId.id
      $scope.enableToSchedule = true if team.accountId is team.teamId.supervisor
      $http.get 'employee/members/' + $scope.teamId
      .success (data) ->
        if data
          $scope.selectedTeam.teammembers = data
      $http.get 'evaluationschedule/list/' + $scope.teamId
      .success (data) ->
        if data
          console.log $scope.selectedTeam.teamSchedules = data

    $scope.showConfirm = (ev) ->
      console.log 'confirming'

    $scope.addForm = () ->
      return

    $scope.deleteSched = (index,schedId) ->
      # console.log index,schedId
      scheduleService.delete schedId
      .success (result) ->
        $scope.selectedTeam.teamSchedules.splice index,1
        appService.alert.success 'Success Deleting Evaluation Schedule'

    $scope.memberEvaluationRequest = (ev) ->
      useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      $mdDialog.show(
        controller: EvalRequestController
        template: JST['employee/home/memberEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope }
        targetEvent: ev
        clickOutsideToClose: true
        fullscreen: useFullScreen).then ((answer) ->
        $scope.status = 'You said the information was "' + answer + '".'
        return
      ), ->
        $scope.status = 'You cancelled the dialog.'
        return
      $scope.$watch (->
        $mdMedia('xs') or $mdMedia('sm')
      ), (wantsFullScreen) ->
        $scope.customFullscreen = wantsFullScreen == true
        return
      return
    $scope.addForm = (ev) ->
      # useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      $mdDialog.show(
        controller: "FormController"
        template: JST['employee/home/addForm.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope }
        targetEvent: ev
        clickOutsideToClose: true

      )


    $scope.alert = (msg) ->
      $mdToast.show(
        $mdToast.simple(msg)
          # .textContent('Simple Toast!')
          .position('top right')
          .hideDelay(5000)
      );
]
EvalRequestController = ($scope, $mdDialog, $http,scopes,scheduleService,appService) ->
  # console.log $scope.accountId
  $scope.teamName = scopes.teamName
  $scope.teammembers = scopes.selectedTeam.teammembers
  $scope.teamId = scopes.teamId
  $scope.accountId = scopes.accountId
  # $scope.items = [1,2,3,4,5];
  $scope.newSched = {}
  $scope.newSched.selected = [];

  $scope.toggle = (item, list) ->
    idx = list.indexOf(item)
    if idx > -1
      list.splice idx, 1
    else
      list.push item
    return

  $scope.exists = (item, list) ->
    list.indexOf(item) > -1

  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.answer = (answer) ->
    $mdDialog.hide answer
    return
  $scope.submit = (newSched) ->
    newSchedule =
      accountId: $scope.accountId
      date: newSched.date
      teamId: $scope.teamId
      type: 'member'
      notes: newSched.notes
      status: 'pending'
      evaluationLimit: newSched.selected.length
      selectedMember: newSched.selected

    scheduleService.checkForExist(scopes.selectedTeam.teamSchedules,newSchedule)
    .then (result) ->
      $mdDialog.hide()
      # console.log 'exist nmn'
      appService.alert.error 'Need to finish the previous evaluation!'
    , (error) ->
      scheduleService.create newSchedule
      .success (result) ->
        tempId = result.teamId
        result.teamId = {}
        result.teamId.id = tempId
        scopes.selectedTeam.teamSchedules.push result

        $mdDialog.hide()
        appService.alert.success 'Success! Wait for confirmation from HR'



    # $http.post 'evaluationschedule/create', newSchedule
    # .success (d) ->

    #   if d
    #     scopes.alert('Success! Wait for confirmation from HR')
    #     scopes.teamSchedules.push d
    #     $mdDialog.hide();
    #   else if d is null
    #     scopes.alert('Finish the previous evaluation first!')

# app.controller 'FormController', ($scope, $http, $rootScope) ->
#     # console.log $rootScope.kpa

#     $scope.kra = $rootScope.kra
#     $scope.addUser = ->
#       $scope.inserted =
#         id: $scope.kra.length+1
#         kpi: ''
#         description:''
#         goal: 0
#         weight: 0

#       $scope.kra.push($scope.inserted);
