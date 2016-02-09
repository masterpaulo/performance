app.controller 'memberEvalRequestController', ($scope, $filter,$mdDialog, $http,scopes,scheduleService,appService,accountType) ->
  $scope.accountType = accountType
  $scope.teamName = scopes.teamName
  $scope.newSched = {}
  $scope.newSched.selected = [];
  $scope.action = scopes.action

  # console.log $scope.accountId
  if accountType is 'employee'
    console.log 'employee'

    $scope.teammembers = scopes.selectedTeam.teammembers
    $scope.teamId = scopes.teamId
    $scope.accountId = scopes.accountId
    $scope.newSched.date = new Date()
    if $scope.action is 'edit'
      console.log 'to edit'
      $http.get 'evaluationschedule/editEvaluation/'+scopes.schedule.id
      .success (result) ->
        console.log 'going to edit'
        console.log $scope.newSched = angular.copy result
        # $scope.newSched.notes = result.notes
        $scope.newSched.date = new Date(result.date)
        $scope.newSched.selected = result.selected
        # console.log 'going to edit evlauation',result
    # $scope.items = [1,2,3,4,5];



  else
    console.log 'hr'
    $scope.newSched.date = new Date(scopes.newSched.date)

    $scope.newSched.notes = scopes.newSched.notes

    $http.get 'employee/members/' + scopes.newSched.teamId
    .success (data) ->
        console.log data
        $scope.teammembers = data
    $http.get 'team/membersForEvaluation/' + scopes.newSched.id
    .success (data) ->
      console.log data
      data.forEach (res) ->
        $scope.newSched.selected.push res.evaluatee
      # $scope.teammembers = data


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
    $scope.hide()
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
      # $mdDialog.hide()
      # console.log 'exist nmn'
      appService.alert.error 'Need to finish the previous evaluation!'
    , (error) ->
      $mdDialog.hide()

      scheduleService.create newSchedule
      .success (result) ->
        # console.log result
        if result
          tempId = result.teamId
          result.teamId = {}
          result.teamId.id = tempId
          scopes.selectedTeam.teamSchedules.push result

          appService.alert.success 'Success! Wait for confirmation from HR'
        else
          appService.alert.error 'Need to create a form first!'
          console.log 'error',result
      # .error (err) ->
      #   console.log err
      #   console.log 'not successful'

  $scope.toConfirmRequest = (status) ->
    console.log 'to confirm',status

    $scope.hide()
    # console.log notif
    console.log scopes.indexNotif
    console.log scopes.notifId
    # console.log '111', key,notif,status
    # console.log key,notif,status
    # console.log notif,status
    d =
      notifId: scopes.notifId
      evalStatus: status
    #  evaluationsched:status, notification:done:true

    $http.put 'notification/update',d
    .success (res) ->
      console.log 'reeeees',res
      if res[0].status is 'active'
        console.log newActiveSched = res[0]
        # a = res[0]
        newActiveSched.teamId = {}
        newActiveSched.teamId.name = res[0].teamName if res[0]
        console.log newActiveSched
        scopes.allSchedules.push newActiveSched
        appService.alert.success 'Evaluation Request Granted'
      else
        appService.alert.error 'Evaluation Request Cancelled'

      scopes.newRequestNotif.splice scopes.indexNotif,1
