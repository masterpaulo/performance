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
    .when "/teams",
      template: JST["hr/team/team.html"]()
      controller:"TeamCtrl"

    .when "/employee",
      template: JST['hr/employee/employee.html']()
      controller: 'EmployeeCtrl'
    .when "/form",
      template: JST['hr/form/form.html']()
      controller: 'FormCtrl'
]

app.controller 'HrCtrl', [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$location'
  '$mdUtil'
  '$mdMedia'
  '$cacheFactory'
  '$q'
  '$timeout'
  '$mdToast'

  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$location,$mdUtil,$mdMedia,$cacheFactory,$q,$timeout,$mdToast) ->
    $scope.userSession = JSON.parse window.userSession
    console.log $scope.accountId = $scope.userSession.id
    $scope.allTeams = $http.get 'team/list'
    .success (result) ->
      return $scope.allTeams = result

    buildToggler = (navID) ->
      debounceFn = $mdUtil.debounce((->
        $mdSidenav(navID).toggle().then ->
          return
        return
      ), 200)
      debounceFn
    $scope.toggleRight = buildToggler('notif')

    $scope.newEmployeeNotif = $http.get 'notification/newEmployee/' + $scope.accountId
    .success (result) ->
      return $scope.newEmployeeNotif = result

    $scope.newRequestNotif = $http.get 'notification/newEvalRequest/'+ $scope.accountId
    .success (result) ->
      console.log result
      return $scope.newRequestNotif = result



    $scope.deleteOnArray = (array,deleteId) ->
      return $q (resolve,reject) ->

        $timeout () ->
          i = 0
          while i < array.length
            if array[i].id is deleteId
              array.splice i,1
              break
            i++
          # console.log array
          if array
            console.log array

            resolve array

        , 1000

    $scope.toggleSidenav = (menuId) ->
      $mdSidenav(menuId).toggle()
      return
    $scope.showNotifs = (selected) ->
      # switch (selected)
      # console.log selected
      $scope.notifSelected = selected
      $scope.toggleRight()
    $scope.cover = false;

    $scope.logout = ->
      console.log "send request to logout"
      document.location = "/auth/logout/"
      return

    $scope.redirect = (path) ->
      $location.url(path)

    $scope.routes = ''

    $scope.alert = (msg) ->
      $mdToast.show(
        $mdToast.simple(msg)
          # .textContent('Simple Toast!')
          .position('top right')
          .hideDelay(5000)
      );

    # $scope.toConfirmRequest = (evalId,status) ->
    #   console.log 'to confirm'
    #   console.log evalId,status

    # $scope.employeeInfo = (ev) ->

    #   # console.log 'employeeInfo', ev
    #   useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
    #   $mdDialog.show(
    #     controller: EmployeeInfoController
    #     template: JST['common/employeeInfo.html']()
    #     parent: angular.element(document.body)
    #     locals: { scopes: ev }
    #     targetEvent: ev
    #     clickOutsideToClose: true
    #     fullscreen: useFullScreen).then ((answer) ->
    #     $scope.status = 'You said the information was "' + answer + '".'
    #     return
    #   ), ->
    #     $scope.status = 'You cancelled the dialog.'
    #     return
    #   $scope.$watch (->
    #     $mdMedia('xs') or $mdMedia('sm')
    #   ), (wantsFullScreen) ->
    #     $scope.customFullscreen = wantsFullScreen == true
    #     return
    #   return
    $scope.toAddTeam = (account,notifId) ->
      # console.log notifId
      useFullScreen = ($mdMedia('sm') or $mdMedia('xs')) and $scope.customFullscreen
      $mdDialog.show(
        controller: EmployeeAddTeamController
        template: JST['hr/EmployeeAddTeam.html']()
        parent: angular.element(document.body)
        locals: { account: account, scopes:$scope, notifId:notifId }
        targetEvent: account
        clickOutsideToClose: true
        fullscreen: useFullScreen).then ((answer) ->
        $scope.status = 'You said the information was "' + answer + '".'
        return
      ), ->
        $scope.status = 'You cancelled the dialog.'
        return
      $scope.$watch (->
        $mdMedia('xs') or $mdMedia('sm')
      ), (wantsFullScreen) ->
        $scope.customFullscreen = wantsFullScreen == true
        return
      return
]


EmployeeAddTeamController = ($scope, $mdDialog, $http,account,scopes,notifId) ->
  # console.log notifId
  $scope.notifId = notifId
  $scope.allTeams = scopes.allTeams
  $scope.account = account
  $scope.teamId = ''
  $scope.newSched = {}
  $scope.newSched.selected = [];

  # $scope.teamSelected =
  $scope.toggle = (item, list) ->
    idx = list.indexOf(item)
    if idx > -1
      list.splice idx, 1
    else
      list.push item
    return

  $scope.teamSelected = (teamId) ->
    # console.log teamId
    $scope.teamId = teamId
    # if $scope.teamSelected
    #   console.log 'already selected'
    #   $scope.teamSelected = ''
    # return $scope.teamSelected = teamId
  # $scope.teamSelected =
  $scope.addTeam = (account,teamName,notifId) ->

    # console.log $scope.teamId
    data =
      accountId: account.id
      teamId: $scope.teamId
    # console.log data
    $http.put 'teammember/create',data
    $http.put 'notification/update/' +  notifId
    .success (res) ->
      if res
        scopes.deleteOnArray(scopes.newEmployeeNotif,notifId)
        .then (ok) ->
          scopes.newEmployeeNotif = ok
        $scope.hide()
        scopes.alert account.lastname + " assigned to team " + teamName

  $scope.exists = (item, list) ->
    list.indexOf(item) > -1

  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.answer = (answer) ->
    $mdDialog.hide answer
    return
