# app.run ($rootScope,scheduleService) ->




app.controller "ScheduleCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$mdUtil'
  '$timeout'
  '$rootScope'
  '$q'
  'scheduleService'
  'teamService'
  'appService'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$mdUtil, $timeout, $rootScope,$q,scheduleService,teamService,appService) ->

    scheduleService.allSchedules()
    .success (result) ->
      console.log 'schedules',result
      return $rootScope.allSchedules = result

    # console.log 'sched', $rootScope.allSchedules
    # console.log 'dlie root', $scope.allSchedules
    # $scope.teams = []
    $scope.accountId = $scope.$parent.accountId
    $scope.newSched = {}
    $scope.newSched.date = new Date()

    buildToggler = (navID) ->
      debounceFn = $mdUtil.debounce((->
        $mdSidenav(navID).toggle().then ->
          return
        return
      ), 200)
      debounceFn
    $scope.toggleRight = buildToggler('right')

    # $scope.cancel = ->
    #   $scope.newSched = {}
    #   $mdDialog.cancel();


    # $scope.close = buildToggler('right').close
    $scope.close = ->
      $scope.newSched = {}
      $mdSidenav('right').close()

    $scope.submitSchedule = (sched) ->
      console.log 'submitting'
      # newdate = scheduleService.formatDate(sched.date)

      newSched =
        accountId: $scope.accountId
        date: sched.date
        teamId: sched.team.id
        type: 'supervisor'
        notes: sched.notes
        evaluationLimit: 1
        status: 'active'

      scheduleService.checkForExist($scope.allSchedules,newSched)
      .then (found) ->
        if found
          appService.alert.error 'You need to finish the previous evaluation'
          $scope.close()
      , () ->
        console.log 'ready to create', newSched
        scheduleService.create(newSched)
        .success (data) ->
          if data
            tempId = data.teamId
            data.teamId = {}
            data.teamId.id = tempId
            data.teamId.name = sched.team.name
            $scope.allSchedules.push data

            $scope.close()
            appService.alert.success 'Success'
    $scope.toDeleteSchedule = (ev, schedId,index) ->
      console.log 'index',index

      confirm = $mdDialog.confirm()
        .title('Are you sure you want to delete it?')
        .content('Deleted evaluation schedule cant be recovered ')
        .targetEvent(ev)
        .ok('Yes')
        .cancel('Cancel');
      $mdDialog.show(confirm)
      .then () ->
        # console.log 'confirming'
        $http.delete 'EvaluationSchedule/delete/'+schedId
        .success (data) ->
          $rootScope.allSchedules.splice index,1
          console.log 'success deleting',data
    $scope.supervisorEvaluationRequest = (ev) ->
      $scope.action = 'toSchedule'

      # console.log 'root',$rootScope.allSchedules
      # console.log 'dli root', $scope.allSchedules

      # useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      console.log 'scheduling'
      $mdDialog.show(
        controller: 'supervisorEvalRequestController'
        template: JST['common/supervisorEvalRequest/supervisorEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope, accountType:'hr' }
        targetEvent: ev
        clickOutsideToClose: true
      )
    $scope.toEditEvaluation =(ev,schedId,i) ->
      $scope.index = i
      $scope.schedId = schedId
      $scope.action = 'edit'
      $mdDialog.show(
        controller: 'supervisorEvalRequestController'
        template: JST['common/supervisorEvalRequest/supervisorEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope, accountType:'hr' }
        targetEvent: ev
        clickOutsideToClose: true
      )


    $scope.toViewEvaluation = (ev,sched) ->
      $scope.action = 'view'

      # console.log sched
      $scope.scheduleId = sched.id
      $scope.type = sched.type
      # $rootScope.toEvaluate =
      #   scheduleId: scheduleId
      #   evaluator: $scope.accountId
      #   evaluatee:'member'

      # console.log $rootScope.toEvaluate
      $mdDialog.show(
        controller: 'evaluationViewController'
        template: JST['hr/evaluationView/evaluationView.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope }
        targetEvent: ev
        clickOutsideToClose: true
      )
    $scope.$parent.routes = 'Evaluation Schedules'
    $scope.schedStatus =[
      true
      false
      false

    ]
    $scope.checkedStatus = [0]
    $scope.checkedFilter = (checked,id) ->
      console.log checked,id
      i = $scope.checkedStatus.indexOf id
      if i is -1
        $scope.checkedStatus.push id

      else

        $scope.checkedStatus.splice(i,1)

      console.log $scope.checkedStatus

]

app.filter 'customFilter', ->
  (schedules,checkedStatus) ->
    console.log schedules,checkedStatus
    out = []
    incomplete = complete= archive = ''
    checkedStatus.forEach (checked) ->
      switch checked
        when 0 then incomplete = 'active'
        when 1 then complete = 'complete'
        when 2 then archive = 'archive'

    if schedules
      schedules.forEach (sched) ->
        if sched.status is incomplete || sched.status is complete || sched.status is archive
          out.push sched
      out
    else
      schedules


