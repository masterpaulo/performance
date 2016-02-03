app = angular.module "EMPLOYEE",["ngResource","ngRoute","ngAnimate", 'ngMaterial', 'ngSails','xeditable','md.data.table']

app.config [
  "$routeProvider"
  "$locationProvider"
  "$mdThemingProvider"
  "$sceDelegateProvider"
  "$httpProvider"
  ($routeProvider, $locationProvider, $mdThemingProvider, $sceDelegateProvider,$httpProvider)->
    $locationProvider.html5Mode true
    # $mdThemingProvider.setDefaultTheme('none');

    $routeProvider
    .when "/",
      template: JST["employee/home/home.html"]()
      controller:"HomeCtrl"
    .when "/form",
      template: JST['common/form/form.html']()
      controller: 'FormCtrl'
    .otherwise redirectTo: '/'

]



#Load the visualization API from google charts
# google.load 'visualization', '1', {packages:['corechart']}

#Initialize the angular app manully here in the controller
#[Make sure to remove ng-app directive from the View]
# google.setOnLoadCallback ()->
#   angular.bootstrap document.body, ['StarterApp']


app.controller 'EmployeeCtrl', [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$location'
  '$rootScope'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$location,$rootScope) ->
    #parse user session data from server
    console.log $scope.userSession = JSON.parse window.userSession
    $scope.accountId = $scope.userSession.id

    $scope.cover = false;

    $scope.notifications = $http.get 'notification/employeeNotif/' + $scope.userSession.id
    .success (result) ->
      if result
        console.log result

        $scope.notifications = result


    $scope.logout = ->
      console.log "send request to logout"
      document.location = "/auth/logout/"
      return


    $scope.redirect = (path) ->
      $location.url(path)

    $scope.routes = ''

    $scope.notifRead = (notifId,i) ->
      $http.put 'notification/read/'+notifId
      .success (data) ->
        console.log 'notif set to read',data
        $scope.notifications.splice i,1



    $rootScope.toEvaluateSupervisor = (ev,scheduleId,teamName) ->
      $scope.teamName = teamName
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
    $rootScope.toEvaluateMember = (ev,scheduleId,teamName) ->
      # console.log 'eval member'
      $scope.teamName = teamName
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
]
