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
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $rp,$mdMedia,$mdToast) ->
    $scope.accountId = $scope.userSession.id

    console.log $scope.userSession.id
    $http.get 'employee/myteam/'+ $scope.accountId,cache:true
    .success (data) ->
      if data
        # console.log data
        $scope.myteams = data
      else
        console.log 'error man'

    $scope.selectedTeam = (team) ->
      console.log team
      $scope.enableToSchedule = false
      $scope.teamName = team.teamId.name
      $scope.teamId =  team.teamId.id
      $scope.enableToSchedule = true if team.accountId is team.teamId.supervisor
      $http.get 'employee/members/' + $scope.teamId, cache: true
      .success (data) ->
        if data
          # console.log data
          $scope.teammembers = data
      $http.get 'evaluationschedule/list/' + $scope.teamId, cache:true
      .success (data) ->
        if data
          # console.log data
          $scope.teamSchedules = data

    # $scope.showAlert = ->
    #   alert = $mdDialog.alert()
    #     .title('Attention, ' + $scope.userName)
    #     .content('This is an example of how easy dialogs can be!')
    #     .ok('Close');

    #   $mdDialog
    #     .show( alert )
    #     .finally( ->
    #       alert = undefined;
    #     )
    $scope.showConfirm = (ev) ->
      console.log 'confirming'

      # confirm = $mdDialog.confirm().title('Would you like to delete your debt?').textContent('All of the banks have agreed to forgive you your debts.').ariaLabel('Lucky day').targetEvent(ev).ok('Please do it!').cancel('Sounds like a scam')
      # $mdDialog.show(confirm).then (->
      #   $scope.status = 'You decided to get rid of your debt.'
      #   return
      # ), ->
      #   $scope.status = 'You decided to keep your debt.'
      #   return
      # return


    $scope.showAdvanced = (ev) ->
      useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      $mdDialog.show(
        controller: DialogController
        template: JST['employee/home/dialog.html']()
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

    $scope.alert = (msg) ->
      $mdToast.show(
        $mdToast.simple(msg)
          # .textContent('Simple Toast!')
          .position('top right')
          .hideDelay(5000)
      );
]
DialogController = ($scope, $mdDialog, $http,scopes) ->
  # console.log $scope.accountId
  $scope.teamName = scopes.teamName
  $scope.teammembers = scopes.teammembers
  $scope.teamId = scopes.teamId
  $scope.accountId = scopes.accountId
  # $scope.items = [1,2,3,4,5];
  $scope.newSched = {}
  $scope.newSched.selected = [];

  # $scope.addMembers = (accountId,value) ->
  #   console.log value
  #   M.push accountId
  #   console.log M
  #   M
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
    newDate = formatDate(newSched.date)
    newSchedule =
      accountId: $scope.accountId
      date: newDate
      teamId: $scope.teamId
      type: 'member'
      notes: newSched.notes
      status: 'pending'
      evaluationLimit: newSched.selected.length
      selectedMember: newSched.selected
    $http.post 'evaluationschedule/create', newSchedule
    .success (d) ->
      # console.log 'success'
      # console.log d
      if d
        # console.log 'error man'
        scopes.alert('Success! Wait for confirmation from HR')
        scopes.teamSchedules.push d
        $mdDialog.hide();
      else if d is null
        scopes.alert('Finish the previous evaluation first!')


  formatDate = (date) ->
    newDate = new Date date
    return newDate.getMonth() + 1 + "/" + newDate.getDate() + "/" + newDate.getFullYear()

