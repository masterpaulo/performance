app.controller "FormCtrl", [
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
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, teamService) ->

    $scope.teamSearch = ""

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
      $scope.selectedTeam = ''
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


    $scope.kra =
      _id: 1
      kras: [
        {
          kpis: [
            {
              'name': 'Attendance'
              'description': 'Monthly goal is 95%\n96% and up = 5\n91%-95%%= 4\n86%-90% = 3.5\n81%-85% = 3\n76%-80%= 2.5\n71%-75%= 2\n66% and below= 1'
              'goal': 5
              'weight': 20
            }
            {
              'name': 'Training Given'
              'description': 'Goal for the month is at least 15% of tasks is ILT\n15% and up = 5\n11%-14% = 4\n6%-10% = 3\n3%-5% = 2\n2% and below = 1'
              'goal': 5
              'weight': 20
            }
            {
              'name': 'Training Taken'
              'description': 'Goal for the month is at least 50% of tasks is training taken for self improvement.\n50% and up = 5\n41%-49% = 4\n31%-40% = 3\n21%-30% = 2\n20% and below = 1'
              'goal': 5
              'weight': 20
            }
            {
              'name': 'Other Tasks'
              'description': 'Goal for the month is at least 35% of tasks is devoted to Admin tasks such as developing content of training materials or training plans, keeping trackers up to date, coordinating schedules and attending meetings.\n35% and up = 5\n26%-34% = 4\n20%-25% = 3\n15%-19% = 2\n14% and below = 1'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Trainee Feedback'
              'description': 'Goal is average rating of 8 out of 10.\n8 and above = 5\n6 to 7= 4\n4 to 5= 3\n2 to 3 = 2\n1 = 1'
              'goal': 5.5002
              'weight': 10
            }
            {
              'name': 'Trainer Evaluation Score'
              'description': 'Monthly goal is score of at least 95%\n96% and up = 5\n91%-95%%= 4\n86%-90% = 3.5\n81%-85% = 3\n76%-80%= 2.5\n71%-75%= 2\n66% and below= 1'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Goals Achieved'
              'description': 'Monthly target is 100%\n100% = 5\n90%-99% = 4\n80%-89% = 3\n70%-79% = 2\n69% and below = 1'
              'goal': 5
              'weight': 10
            }
          ]
          weight: 80
          tmp: {}
          name: 'TRAINING TASKS'
          description: 'Tasks and responsibilities that need to accomplished in training.'
        }
        {
          kpis: [
            {
              'name': 'Technical & Professional Knowledge'
              'description': 'Remains current on technical developments in necessary area of expertise.  Possesses in-depth professional knowledge of the field. Seeks new knowledge as necessary.'
              'goal': 5
              'weight': 15
            }
            {
              'name': 'Communication Skills'
              'description': 'Communicates clearly and concisely both orally and written form.  Listens and processes information well and in a timely fashion. Provides clear instructions and guidelines. Shares information with others.'
              'goal': 5
              'weight': 15
            }
            {
              'name': 'Interpersonal Skills/Service Oriented'
              'description': 'Ability to interact effectively and courteously, tactfully and efficiently with, internal and external constituents. Fosters community and builds peer relationships. Team player.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Decision Making'
              'description': 'Capable of gathering facts, analyzing problems, identifying and implementing solutions.  Exhibits sound judgment.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Work Discipline'
              'description': 'A role model. Goes beyond what the job demands to lead the organization in meeting objectives.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Enthusiasm for Work'
              'description': 'Enthusiasm for work is contagious and is evidence by superb performance.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Initiative'
              'description': 'Takes charge of situations as necessary. Assumes more responsibility. Serves as a role model. Acts independently, as appropriate. Promotes innovative changes.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Integrity'
              'description': 'Actions and decisions are always trusted and respected. Organization recognizes employee for demonstrating integrity and honesty.'
              'goal': 5
              'weight': 10
            }
            {
              'name': 'Punctuality'
              'description': 'Dependable and punctual.'
              'goal': 5
              'weight': 10
            }
          ]
          weight: 20
          tmp: {}
          name: 'TRAINER ATTRIBUTES'
          description: 'Personality and character that a trainer needs to uphold.'
        }
      ]
      type: 'member'
      status: 1
      version: 0
      team: 7


    return
]




# {
#     "_id" : ObjectId("545b1d0232b78f62733df098"),
#     "kras" : [ 
#         {
#             "kpis" : [ 
#                 {
#                     "name" : "Attendance",
#                     "description" : "Monthly goal is 95%\n96% and up = 5\n91%-95%%= 4\n86%-90% = 3.5\n81%-85% = 3\n76%-80%= 2.5\n71%-75%= 2\n66% and below= 1",
#                     "goal" : 5,
#                     "weight" : 20
#                 }, 
#                 {
#                     "name" : "Training Given",
#                     "description" : "Goal for the month is at least 15% of tasks is ILT\n15% and up = 5\n11%-14% = 4\n6%-10% = 3\n3%-5% = 2\n2% and below = 1",
#                     "goal" : 5,
#                     "weight" : 20
#                 }, 
#                 {
#                     "name" : "Training Taken",
#                     "description" : "Goal for the month is at least 50% of tasks is training taken for self improvement.\n50% and up = 5\n41%-49% = 4\n31%-40% = 3\n21%-30% = 2\n20% and below = 1",
#                     "goal" : 5,
#                     "weight" : 20
#                 }, 
#                 {
#                     "name" : "Other Tasks",
#                     "description" : "Goal for the month is at least 35% of tasks is devoted to Admin tasks such as developing content of training materials or training plans, keeping trackers up to date, coordinating schedules and attending meetings.\n35% and up = 5\n26%-34% = 4\n20%-25% = 3\n15%-19% = 2\n14% and below = 1",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Trainee Feedback",
#                     "description" : "Goal is average rating of 8 out of 10.\n8 and above = 5\n6 to 7= 4\n4 to 5= 3\n2 to 3 = 2\n1 = 1",
#                     "goal" : 5,5002
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Trainer Evaluation Score",
#                     "description" : "Monthly goal is score of at least 95%\n96% and up = 5\n91%-95%%= 4\n86%-90% = 3.5\n81%-85% = 3\n76%-80%= 2.5\n71%-75%= 2\n66% and below= 1",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Goals Achieved",
#                     "description" : "Monthly target is 100%\n100% = 5\n90%-99% = 4\n80%-89% = 3\n70%-79% = 2\n69% and below = 1",
#                     "goal" : 5,
#                     "weight" : 10
#                 }
#             ],
#             "weight" : 80,
#             "tmp" : {},
#             "name" : "TRAINING TASKS",
#             "description" : "Tasks and responsibilities that need to accomplished in training."
#         }, 
#         {
#             "kpis" : [ 
#                 {
#                     "name" : "Technical & Professional Knowledge",
#                     "description" : "Remains current on technical developments in necessary area of expertise.  Possesses in-depth professional knowledge of the field. Seeks new knowledge as necessary.",
#                     "goal" : 5,
#                     "weight" : 15
#                 }, 
#                 {
#                     "name" : "Communication Skills",
#                     "description" : "Communicates clearly and concisely both orally and written form.  Listens and processes information well and in a timely fashion. Provides clear instructions and guidelines. Shares information with others.",
#                     "goal" : 5,
#                     "weight" : 15
#                 }, 
#                 {
#                     "name" : "Interpersonal Skills/Service Oriented",
#                     "description" : "Ability to interact effectively and courteously, tactfully and efficiently with, internal and external constituents. Fosters community and builds peer relationships. Team player.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Decision Making",
#                     "description" : "Capable of gathering facts, analyzing problems, identifying and implementing solutions.  Exhibits sound judgment.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Work Discipline",
#                     "description" : "A role model. Goes beyond what the job demands to lead the organization in meeting objectives.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Enthusiasm for Work",
#                     "description" : "Enthusiasm for work is contagious and is evidence by superb performance.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Initiative",
#                     "description" : "Takes charge of situations as necessary. Assumes more responsibility. Serves as a role model. Acts independently, as appropriate. Promotes innovative changes.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Integrity",
#                     "description" : "Actions and decisions are always trusted and respected. Organization recognizes employee for demonstrating integrity and honesty.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }, 
#                 {
#                     "name" : "Punctuality",
#                     "description" : "Dependable and punctual.",
#                     "goal" : 5,
#                     "weight" : 10
#                 }
#             ],
#             "weight" : 20,
#             "tmp" : {},
#             "name" : "TRAINER ATTRIBUTES",
#             "description" : "Personality and character that a trainer needs to uphold."
#         }
#     ],
#     "type" : "member",
#     "status" : 1,
#     "version" : 0,
#     "team" : 7,
#     "createdAt" : ISODate("2014-11-06T07:02:26.072Z"),
#     "updatedAt" : ISODate("2014-11-06T07:26:21.944Z")
# }