app.controller 'supervisorEvalRequestController', ($scope, $filter,$mdDialog, $http,scopes,scheduleService,appService,accountType,$rootScope,hrService,$q) ->
  $scope.teams = $rootScope.teams
  $scope.newSched = {}
  $scope.newSched.selected = [];
  $scope.newSched.date = new Date()
  $scope.allSchedules = $rootScope.allSchedules
  console.log 'allsched',$scope.allSchedules
  # console.log $scope.teams.supervisor
  $scope.teamSelected = (team) ->
    $scope.supervisor = team.supervisor
    $scope.teamId = team.id
    $scope.teamName = team.name
    console.log 'teamSelected',team
    hrService.membersInfo(team)
    .success (data) ->
      $scope.teammembers =  data.members

    # $scope.teamSchedules =





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
    console.log 'cancelling'
    $mdDialog.cancel()
    return

  $scope.answer = (answer) ->
    $mdDialog.hide answer
    return
  $scope.submit = (newSched) ->
    # console.log newSched
    newSchedule =
      accountId: $scope.accountId
      date: newSched.date
      teamName: newSched.team.name
      teamId: newSched.team.id
      type: 'supervisor'
      notes: newSched.notes
      status: 'active'
      evaluationLimit: newSched.selected.length
      selectedMember: newSched.selected
    # console.log newSchedule
    scheduleService.checkForExist($scope.allSchedules,newSchedule)
    .then (result) ->
      # $mdDialog.hide()
      # console.log 'exist nmn'
      appService.alert.error 'Need to finish the previous evaluation!'
    , (error) ->
      # console.log 'creating new sched'
      $mdDialog.hide()

      scheduleService.create newSchedule
      .success (result) ->
        console.log result
        if result
          tempId = result.teamId
          result.teamId = {}
          result.teamId.id = tempId
          result.teamId.name = newSchedule.teamName
          $scope.allSchedules.push result

          appService.alert.success 'Success! Wait for confirmation from HR'
        else
          appService.alert.error 'Create a form first!'
