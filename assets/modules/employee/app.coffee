app = angular.module "EMPLOYEE",["ngResource","ngRoute","ngAnimate", 'ngMaterial', 'ngSails']


# app.run ($rootScope,teamService) ->
  # $rootScope.teams = []
  # teamService.listTeams()
  # .success (result) ->
  #   console.log result
  #   return $rootScope.teams = result

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





app.controller 'HrCtrl', [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$location'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$location) ->
    #parse user session data from server
    $scope.userSession = JSON.parse window.userSession

    console.log $scope.userSession
    # $scope.z = 'aaaaaaaaaa'

    $scope.cover = false;

    $scope.notifications = $http.get 'notification/message/' + $scope.userSession.id
    .success (result) ->
      if result
        console.log result
        $scope.notifications = result



    #Function that should be called when opening the main menu (the arrow-down button on the top right)
    # $scope.openMainMenu = ()->
    #   return null


    # #Toggl Sidenav
    # $scope.toggleSidenav = (menuId) ->
    #   $mdSidenav(menuId).toggle()
    #   return

    $scope.logout = ->
      console.log "send request to logout"
      document.location = "/auth/logout/"
      return

    $scope.redirect = (path) ->
      $location.url(path)

    $scope.routes = ''

    # $scope.viewSwitcher = (roleId) ->
    #   console.log 'switchinggggggggggggggg'
    #   appService.viewSwitcher 'roleId'


]
