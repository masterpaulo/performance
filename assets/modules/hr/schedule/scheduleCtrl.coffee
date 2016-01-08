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
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$mdUtil, $timeout, $rootScope,$q,scheduleService,teamService) ->
    # $scope.teams = []
    $scope.accountId = $scope.$parent.accountId

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

    scheduleService.activeSchedules()
    .success (result) ->
      $rootScope.activeSchedules = result

    $scope.toSchedule = () ->
      $scope.newSched = {}
      $scope.toggleRight()



    $scope.submitSchedule = (sched) ->
      console.log 'submitting'
      newdate = scheduleService.formatDate(sched.date)

      newSched =
        accountId: $scope.accountId
        date: newdate
        teamId: sched.team.id
        type: 'supervisor'
        notes: sched.notes
        evaluationLimit: 1
        status: 'active'

      scheduleService.checkForExist($scope.activeSchedules,newSched)
      .then (found) ->
        if found
          $rootScope.alert 'You need to finish the previous evaluation'
          $scope.close()
        else
          scheduleService.create(newSched)
          .success (data) ->
            if data
              tempId = data.teamId
              data.teamId = {}
              data.teamId.id = tempId
              data.teamId.name = sched.team.name
              $scope.activeSchedules.push data

              $scope.close()
              $scope.$parent.alert 'Success'


    $scope.$parent.routes = 'Evaluation Schedules'


]
