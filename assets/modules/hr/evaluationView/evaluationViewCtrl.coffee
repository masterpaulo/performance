app.controller "evaluationViewController", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$mdBottomSheet'
  '$mdMedia'
  'formService'
  '$rootScope'
  'scopes'
  'appService'
  'scheduleService'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, formService,$rootScope,scopes,appService,scheduleService) ->
    # console.log $scope.teamId = scopes.teamId
    console.log $scope.scheduleId = scopes.scheduleId
    console.log $scope.type = scopes.type

    scheduleService.evaluationView $scope.scheduleId
    .success (data) ->
      if data
        console.log 'data',data
        $scope.evaluations = data
    # if $scope.type is 'supervisor'
    #   # console.log $scope.data.evaluatee
    #   $http.get 'form/evaluatesupervisor', {params: $scope.data}
    #   .success (data) ->

    #     data.kras = data.formId.kras if data.kras is undefined
    #     $scope.supervisorEvaluation = data

    # else
    #   $http.get 'form/evaluatemember', {params: $scope.data}
    #   .success (data) ->
    #     # c=0
    #     data.forEach (result,key) ->
    #       # console.log typeof data[key].kras
    #       data[key].kras = result.formId.kras if data[key].kras is undefined
    #       if (key+1) is data.length
    #         console.log $scope.memberEvaluations = data


    $scope.hide = () ->
      $mdDialog.hide()

]





