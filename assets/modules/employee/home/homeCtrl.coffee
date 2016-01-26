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
  'employeeService'
  '$location'
  '$rootScope'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $rp,$mdMedia,$mdToast,scheduleService,appService, employeeService,$location,$rootScope) ->
    $scope.accountId = $scope.userSession.id
    $scope.enableToSchedule = false
    employeeService.myteam $scope.accountId
    .success (data) ->
      $scope.myteams = data

    $scope.selectedTeam = (team) ->
      # console.log team
      # $scope.supervisor = true if team.accountId is team.teamId.supervisor
      $scope.supervisor = team.supervisor

      $scope.teamName = team.teamId.name
      $scope.teamId =  team.teamId.id
      $scope.enableToSchedule = true if team.accountId is team.teamId.supervisor
      console.log $scope.filterByType = if $scope.enableToSchedule then 'member' else 'supervisor'


      employeeService.teammembers $scope.teamId
      .success (data) ->
        console.log data
        $scope.selectedTeam.teammembers = data

      scheduleService.findByTeam $scope.teamId
      .success (data) ->
        console.log data
        $scope.selectedTeam.teamSchedules = data

    # $scope.toEvaluateSupervisor = (ev,scheduleId) ->
    #   $rootScope.toEvaluate =
    #     scheduleId: scheduleId
    #     evaluator: $scope.accountId


    #   $mdDialog.show(
    #     controller: 'EvaluateCtrl'
    #     template: JST['common/evaluation/evaluation.html']()
    #     parent: angular.element(document.body)
    #     locals: { scopes: $scope }
    #     targetEvent: ev
    #     clickOutsideToClose: true
    #   )

    $scope.toEvaluateSupervisor = (ev,scheduleId) ->

      $rootScope.toEvaluate =
        scheduleId: scheduleId
        evaluator: $scope.accountId
        evaluatee:'supervisor'


      $mdDialog.show(
        controller: 'EvaluateCtrl'
        template: JST['common/evaluationForm/evaluation.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope }
        targetEvent: ev
        clickOutsideToClose: true
      )
    $scope.toEvaluateMember = (ev,scheduleId) ->
      $rootScope.toEvaluate =
        scheduleId: scheduleId
        evaluator: $scope.accountId
        evaluatee:'member'

      console.log $rootScope.toEvaluate
      $mdDialog.show(
        controller: 'EvaluateCtrl'
        template: JST['common/evaluationForm/evaluation.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope }
        targetEvent: ev
        clickOutsideToClose: true
      )
      # console.log 'to eval supervisor'

      # $location.url('evaluation/supervisor/' + scheduleId)
    $scope.showConfirm = (ev) ->
      console.log 'confirming'

    $scope.deleteSched = (index,schedId) ->
      # console.log index,schedId
      scheduleService.delete schedId
      .success (result) ->
        $scope.selectedTeam.teamSchedules.splice index,1
        appService.alert.success 'Success Deleting Evaluation Schedule'

    $scope.memberEvaluationRequest = (ev) ->
      # useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      $mdDialog.show(
        controller: 'memberEvalRequestController'
        template: JST['common/evaluationRequest/memberEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope, accountType:'employee' }
        targetEvent: ev
        clickOutsideToClose: true
      )

    $scope.showConfirm = (ev,index,schedId) ->

      confirm = $mdDialog.confirm()
        .title('Are you sure you want to delete this schedule?')
        .content('The deleted schedule cannot be undo!')
        .targetEvent(ev)
        .ok('OK')
        .cancel('CANCEL')

      $mdDialog.show(confirm).then (->
        $scope.deleteSched index,schedId
        return
      ), ->
        console.log $scope.status = 'You decided to cancel.'
        return

      return

    form = {
      "kras" : [
        {
          "kpis" : [
            {
                "name" : ""
                "description" : ""
                "goal" : 0
                "weight" : 0
            }
          ]
          "weight" : 0
          "tmp" : {}
          "name" : ""
          "description" : ""
        },
        {
          "kpis" : [
            {
                "name" : ""
                "description" : ""
                "goal" : 0
                "weight" : 0
            }
          ]
          "weight" : 0
          "tmp" : {}
          "name" : ""
          "description" : ""
        },
        {
          "kpis" : [
            {
                "name" : ""
                "description" : ""
                "goal" : 0
                "weight" : 0
            }
          ]
          "weight" : 0
          "tmp" : {}
          "name" : ""
          "description" : ""
        },
        {
          "kpis" : [
            {
                "name" : ""
                "description" : ""
                "goal" : 0
                "weight" : 0
            }
          ]
          "weight" : 0
          "tmp" : {}
          "name" : ""
          "description" : ""
        },

      ],
      "type" : "supervisor"
      "status" : true
      "version" : 0
    }
    $scope.form = form
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

