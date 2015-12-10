

app = angular.module "HR",["ngResource","ngRoute","ngAnimate", 'ngMaterial', 'ngSails']

app.config [
  "$routeProvider"
  "$locationProvider"
  "$mdThemingProvider"
  "$sceDelegateProvider"
  ($routeProvider, $locationProvider, $mdThemingProvider, $sceDelegateProvider)->
    $locationProvider.html5Mode true
    # $mdThemingProvider.setDefaultTheme('none');

    $routeProvider
    .when "/",
      template: JST["hr/schedule/schedule.html"]()
      controller:"ScheduleCtrl"
    .when "/team",
      template: JST["hr/home/home.html"]()
      controller:"HomeCtrl"
    .when "/employee",
      template: JST['hr/employee/employee.html']()
      controller: 'EmployeeCtrl'
    # .otherwise redirectTo: '/'
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


    $scope.cover = false;



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

    # # $scope.test = ()->
    # #   console.log "Testing here: "
    # #   console.log JST["admin/home/home.html"]()

    # $scope.showDialog = (env)->
    #   $mdDialog.show(
    #     $mdDialog.alert()
    #       .clickOutsideToClose(true)
    #       .title('This is an alert title')
    #       .content('You can specify some description text in here.')
    #       .ariaLabel('Alert Dialog Demo')
    #       .ok('Got it!')
    #       .targetEvent(env)
    #   )


    # #transfer to specific controller
    # $scope.confirmDialog = (env)->
    #   confirm = $mdDialog.confirm()
    #     .title('Would you like to delete your debt?')
    #     .content("All of the banks have agreed to <span >forgive</span> you your debts.")
    #     .ariaLabel('Lucky day')
    #     .targetEvent(env)
    #     .ok('Please do it!')
    #     .cancel('Sounds like a scam');

    #   $mdDialog.show(confirm)
    #   .then(
    #     () ->
    #       $scope.status = 'You decided to get rid of your debt.';
    #     ,
    #     ()->
    #       $scope.status = 'You decided to keep your debt.';
    #   )
    $scope.redirect = (path) ->
      $location.url(path)

    $scope.routes = ''


    # return
]
