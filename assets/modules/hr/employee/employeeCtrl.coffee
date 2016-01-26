# app.service 'BookService', (CacheFactory) ->
#   if !CacheFactory.get('bookCache')
#     # or CacheFactory('bookCache', { ... });
#     CacheFactory.createCache 'bookCache',
#       deleteOnExpire: 'aggressive'
#       recycleFreq: 60000
#   bookCache = CacheFactory.get('bookCache')
#   { findBookById: (id) ->
#     $http.get '/account/list/' + id, cache: bookCache
#  }


app.controller "EmployeeCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$location'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$location) ->

    # $scope.cache = CacheManager.init "EmployeeCtrl"
    # $scope.cache
    #   .register "list","/auth/list"



    $scope.employees = []
    $scope.searchOn = false
    $scope.viewEmployee = () ->
      console.log 'this is it'

    # $scope.toggleSearch = () ->
    #   if $scope.searchOn
    #     $scope.searchOn = false
    #   else
    #     $scope.searchOn = true
    $scope.$parent.routes = 'Employees'

    $http.get 'account/list'
    .success (result) ->
      if result
        console.log 'employeees', result
        $scope.employees = result
    # $scope.search = false
    $scope.toggleSearch = () ->
      console.log $scope.search
      $scope.search = if $scope.search then false else true



]
