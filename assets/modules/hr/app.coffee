app = angular.module "HR",["ngResource","ngRoute","ngAnimate", 'ngMaterial', 'ngSails','md.data.table','angular-momentjs']

app.run (teamService,$rootScope) ->
  teamService.listTeams()
  .success (result) ->
    console.log 'teams', result
    return $rootScope.teams = result


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
      template: JST['common/form/form.html']()
      controller: 'FormCtrl'
    .otherwise redirectTo: '/'

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
  '$rootScope'
  'teamService'
  'appService'
  'scheduleService'
  '$moment'


  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog,$location,$mdUtil,$mdMedia,$cacheFactory,$q,$timeout,$mdToast,$rootScope,teamService,appService,scheduleService,$moment) ->
    $scope.userSession = JSON.parse window.userSession
    $scope.accountId = $scope.userSession.id
    # $http.get 'team/list'
    # .success (result) ->
    #   return $scope.allTeams = result

    buildToggler = (navID) ->
      debounceFn = $mdUtil.debounce((->
        $mdSidenav(navID).toggle().then ->
          return
        return
      ), 200)
      debounceFn
    $scope.toggleRight = buildToggler('notif')

    $http.get 'notification/newEmployee/' + $scope.accountId
    .success (result) ->
      console.log result
      return $scope.newEmployeeNotif = result

    $http.get 'notification/newEvalRequest/'+ $scope.accountId
    .success (result) ->
      if result
        console.log result

        return $scope.newRequestNotif = result
      else
        console.log 'empty request'
    $scope.newHrNotifLength = 0
    $http.get 'notification/hrNotif/'+$scope.accountId
    .success (result) ->
      if result
        console.log 'result',result
        $scope.HrNotif = result
        $scope.HrNotif.forEach (newNotif,key) ->
          # $scope.HrNotif[key].createdAt = $moment(newNotif.createdAt).fromNow()

          if newNotif.done is false
            $scope.newHrNotifLength++


    $scope.notifRead = (notif) ->
      notifId = notif.id
      # console.log notif
      if notif.done is false
        $http.put 'notification/read/'+notifId
        .success (result) ->
          console.log 'done read',result
          $scope.newHrNotifLength--

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

    $scope.memberEvaluationRequest = (ev,indexNotif,reqNotif) ->
      $scope.notifId = reqNotif.id
      $scope.teamName = reqNotif.teamName
      $scope.indexNotif = indexNotif
      # $scope.selectedScheduleId = reqNotif.scheduleId.id
      # $scope.teamId = reqNotif.scheduleId.teamId
      # $scope.schedDate = reqNotif.scheduleId.date
      # $scope
      $scope.newSched = reqNotif.scheduleId

      $mdDialog.show(
        controller: 'memberEvalRequestController'
        template: JST['common/evaluationRequest/memberEvalRequest.html']()
        parent: angular.element(document.body)
        locals: { scopes: $scope, accountType:'hr'}
        targetEvent: ev
        clickOutsideToClose: true

      )

    $scope.query = {
      order: 'name',
      limit: 10,
      page: 1
    };


    # $scope.logPagination = (page, limit) ->
    #   console
    #   log('limit: ', limit);


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

app.filter 'timeago', ($moment) ->
  (date) ->
    # console.log 'dateeee', $moment(date).fromNow()
    return $moment(date).fromNow()




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
        appService.alert.success account.lastname + " assigned to team " + teamName

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

