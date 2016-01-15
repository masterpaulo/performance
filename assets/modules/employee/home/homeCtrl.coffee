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
        controller: 'memberEvalRequestController'
        template: JST['common/evaluationRequest/memberEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope, accountType:'employee' }
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
    # $scope.addForm = (ev) ->
    #   # useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
    #   $mdDialog.show(
    #     controller: "FormController"
    #     template: JST['employee/home/addForm.html']()
    #     parent: angular.element(document.body)
    #     locals: { scopes: $scope }
    #     targetEvent: ev
    #     clickOutsideToClose: true

    #   )

]

