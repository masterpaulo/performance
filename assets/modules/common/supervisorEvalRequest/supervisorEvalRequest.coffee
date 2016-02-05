app.controller 'supervisorEvalRequestController', ($scope, $filter,$mdDialog, $http,scopes,scheduleService,appService,accountType,$rootScope,hrService,$q) ->
  $scope.teams = $rootScope.teams
  $scope.newSched = {}
  $scope.newSched.selected = [];
  $scope.newSched.date = new Date()
  $scope.allSchedules = $rootScope.allSchedules
  # $scope.changeCount = -1
  console.log 'allsched',$scope.allSchedules
  $scope.action = scopes.action
  # console.log 'action',action
  if $scope.action is 'edit'
    console.log 'to edittt'
    scheduleService.editEvaluation scopes.schedId
    .success (sched) ->
      console.log 'to edit sched', sched
      $scope.newSched = sched
      $scope.newSched.date = new Date($scope.newSched.date)
      $scope.oldSched = angular.copy $scope.newSched
      # $scope.$watch 'newSched',
      #   () ->
      #     console.log $scope.changeCount += 1
      #   , true

      # $scope.oldSched = Copy $scope.newSched
      # $scope.newSched.team = 'Bus'

      # $scope.newSched.team = $scope.newSched.teamId.name

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

    # member.accountId.id===supervisor.id



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
    $scope.newSched = {}
    $mdDialog.hide()
    return

  $scope.cancel = ->
    console.log 'cancelling'
    $scope.newSched = {}
    $mdDialog.cancel()
    return

  $scope.answer = (answer) ->
    $mdDialog.hide answer
    return



  $scope.editFinish = (sched) ->
    if $scope.oldSched.selected.sort().toString() isnt sched.selected.sort().toString()
      console.log sched.selectedEdit = true

    scheduleService.editFinish sched
    .success (data) ->
      $scope.cancel()
      scopes.allSchedules[scopes.index].date = data[0][0].date
      scopes.allSchedules[scopes.index].notes = data[0][0].notes
      scopes.allSchedules[scopes.index].evaluationLimit = data[0][0].evaluationLimit


      appService.alert.success 'Editing is success'
      console.log 'success edit', data

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
