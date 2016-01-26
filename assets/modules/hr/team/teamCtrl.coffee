app.controller "TeamCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  '$mdBottomSheet'
  '$mdMedia'
  'teamService'
  '$rootScope'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, teamService,$rootScope) ->

    $scope.teamSearch = ""

    $scope.selectedTeam = '';
    $scope.teams = []

    teamService.listTeams()
    .success (data) ->
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
            $scope.updatedTeam = angular.copy data
            $scope.showUpdateButton = false
      return

    $scope.updateTeam = () ->
      update = {
        name : $scope.updatedTeam.name
        parent : $scope.updatedTeam.parent
      }
      teamService.updateTeam $scope.selectedTeam.id, update
      .then (data) ->
        $scope.selectedTeam = data[0]
        $scope.showUpdateButton = false

    $scope.closeTeam = () ->
      $scope.selectedTeam = ''
      return

    $scope.promote = (member) ->
      teamService.setSupervisor($scope.selectedTeam,member)
      .then (data) ->
        $scope.selectedTeam.supervisor = member.id

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
        locals: {Teams:$scope.teams}
        clickOutsideToClose: true
        fullscreen: $mdMedia('sm') and $scope.customFullscreen).then ((newTeam) ->
          console.log "I got the new Team"
          console.log newTeam

          teamService.addTeam newTeam
          .then (data)->
            console.log "in TeamCtrl"
            console.log data

            $scope.teams.push data
            $scope.teamSearch = ''
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

    $scope.showMemberBottomSheet = ($event) ->
      $scope.alert = ''
      $mdBottomSheet.show(
        templateUrl: 'templates/hr/team/MemberBotSheet.html'
        controller: MemberBottomSheetCtrl
        parent: "#member-tab"
        locals: {Team:$scope.selectedTeam}
        targetEvent: $event).then (user) ->
          newMembership = {
            accountId : user.id
            teamId : $scope.selectedTeam.id
          }
          teamService.addMember newMembership
          .then (data) ->
            console.log "in TeamCtrl"
            console.log data
            $scope.selectedTeam.members.push user

        return
      return

    return
]


# put in a separate file

AddTeamController = ($scope, $mdDialog, Teams) ->

  $scope.newTeam = {}
  $scope.teams = Teams
  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.save = ->
    $mdDialog.hide($scope.newTeam)
    return

  return


# put in separate file
 MemberBottomSheetCtrl = ($http, $scope, $mdBottomSheet, Team, teamService) ->
  $scope.users = []

  $http.get 'account/list'
      .success (data) ->
        if data
          console.log data
          $scope.users = data

  $scope.name = Team.name
  $scope.addMember = (user) ->
    $mdBottomSheet.hide user
    return
  return
