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
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$mdUtil, $timeout, $rootScope) ->
    $scope.teams = []

    buildToggler = (navID) ->
      debounceFn = $mdUtil.debounce((->
        $mdSidenav(navID).toggle().then ->
          return
        return
      ), 200)
      debounceFn
    $scope.toggleRight = buildToggler('right')

    $http.get 'team/list'
    .success (result) ->
      if result
        # console.log result
        $scope.teams = result


    $http.get 'evaluationschedule/list'
    .success (result) ->
      if result
        console.log result
        $scope.evaluationschedules = result

    $scope.toSchedule = () ->
      $scope.toggleRight()

    formatDate = (date) ->
      newDate = new Date date
      return newDate.getMonth() + 1 + "/" + newDate.getDate() + "/" + newDate.getFullYear()
    $scope.submitSchedule = (sched) ->
      console.log 'submitting'
      newdate = formatDate(sched.date)

      newSched =
        date: newdate
        teamId: sched.team.id
        type: 'supervisor'
        notes: sched.notes
        evaluationLimit: 1

      $http.post 'evaluationschedule/create', newSched
      .success (data) ->
        if data
          tempId = data.teamId
          data.teamId = {}
          data.teamId.id = tempId
          data.teamId.name = sched.team.name
          $scope.evaluationschedules.push data

      # $scope.evaluationschedules.forEach (evaluation) ->
        # ready = false;
        # console.log evaluation
        # if evaluation.teamId.id is sched.team.id and !evaluation.done
        #   console.log 'you need to finish the previous evaluation'

        # else
        #   console.log 'ready to schedule'
        #   ready = true

      # if ready

    $scope.$parent.routes = 'Evaluation Schedules'

    $scope.sample = () ->
      console.log 'zzzzzzzzzzzzzzzzzzzzzz'
      $scope.toggleRight()

]
