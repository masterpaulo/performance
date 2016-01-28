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



    # $scope.close = buildToggler('right').close
    $scope.close = ->
      $scope.newSched = {}
      $mdSidenav('right').close()

    # $http.get 'team/list'
    # .success (result) ->
    #   if result
    #     # console.log result
    #     $rootScope.teams = result
    # teamService.listTeams()
    # .success (result) ->
    #   $rootScope.teams = result

    # scheduleService.activeSchedules()
    # .success (result) ->
    #   $rootScope.activeSchedules = result

    $scope.toSchedule = () ->
      $scope.newSched = {}
      $scope.toggleRight()



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

      scheduleService.checkForExist($scope.activeSchedules,newSched)
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
            $scope.activeSchedules.push data

            $scope.close()
            appService.alert.success 'Success'

    $scope.supervisorEvaluationRequest = (ev) ->
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

    $scope.toViewEvaluation = (ev,sched) ->
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


]
