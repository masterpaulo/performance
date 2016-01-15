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
    $scope.userSession = JSON.parse window.userSession
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

    $rootScope.kra = [
      # kpi: ''
      # description: ''
    ]


]
