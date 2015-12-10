app = angular.module "PerformanceApp",["ngResource","ngRoute","ngAnimate", 'ngMaterial', 'ngSails']

# app.config [
#   "$routeProvider"
#   "$locationProvider"
#   ($routeProvider, $locationProvider)->
    # $locationProvider.html5Mode true

    # $routeProvider
    # .when "/",
    #   template: JST["hr/home/home.html"]()
    #   controller:"App"
# ]


# app.run ($http)->
  # $http.defaults.headers.common['food-api'] = true

# app.controller "LoginCtrl",[
#   "$scope"
#   ($s)->
#     $s.login = ->
#       document.location = "/auth/google/"
#     return
# ]


app.controller 'PublicCtrl', [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog) ->
    $scope.loginStatus = false
    $scope.toggleSidenav = (menuId) ->
      $mdSidenav(menuId).toggle()
      return

    $scope.login = ->
      $scope.loginStatus = true
      console.log "send request to login"
      document.location = "/auth/google/"
      return

    return
]
