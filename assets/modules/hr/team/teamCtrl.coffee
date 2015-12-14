app.controller "TeamCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$mdMedia'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdMedia) ->


    $scope.selectedTeam = '';
    $scope.teams = []

    $http.get 'team/list'
      .success (data) ->
        if data
          console.log data
          $scope.teams = data



    $scope.addTeam = ()->
      console.log "Adding team"
      $scope.showAddTeamForm()
      return

    $scope.selectTeam = (team) ->
      $http.get 'team/get/'+team.id
        .success (data) ->
          if data 
            console.log data
            $scope.selectedTeam = data
      return

    $scope.closeTeam = () ->
      $scope.selectedTeam = {}
      return

    $scope.toggleSidenav = (menuId) ->
      $mdSidenav(menuId).toggle()
      return

    $scope.test = ()->
      console.log "Testing"
      return

    $scope.showAddTeamForm = (ev) ->
      $mdDialog.show(
        controller: AddTeamController
        templateUrl: 'templates/hr/team/dialogAddTeam.html'
        parent: angular.element(document.body)
        targetEvent: ev
        clickOutsideToClose: true
        fullscreen: $mdMedia('sm') and $scope.customFullscreen).then ((newTeam) ->
        console.log "I got the new Team"
        console.log newTeam
        $scope.teams.push newTeam
        return
      ), ->
        $scope.status = 'No data passed.'
        return
      $scope.$watch (->
        $mdMedia 'sm'
      ), (sm) ->
        $scope.customFullscreen = sm == true
        return
      return


    return
]

AddTeamController = ($scope, $mdDialog, $http) ->

  $scope.team = {}

  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.save = ->
    console.log "Saving new team"
    console.log $scope.team


    $http.put 'team/create', $scope.team
      .success (data) ->
        if data
          console.log data

          $mdDialog.hide(data)
    return

  return