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
  'formService'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, formService) ->

    $scope.teamSearch = ""
    $scope.editForm = 0;

    $scope.selectedTeam = '';
    $scope.teams = []
    formZero = {
      "kras" : [ 
        {
          "kpis" : [ 
            {
                "name" : ""
                "description" : ""
                "goal" : 0
                "weight" : 0
            }
          ]
          "weight" : 0
          "tmp" : {}
          "name" : ""
          "description" : ""
        }, 
        
      ],
      "status" : true
      "version" : 0
    }

    if $scope.$parent.userSession.currentRole == "1"
      formService.getForm("supervisor")
      .then (data) ->
        console.log "in FormCtrl"


        form = data.data[0]
        if(form)
          $scope.form = form
        
        else
          formZero.type = "supervisor"
          $scope.form = formZero
        
    else
      $scope.accountId = $scope.userSession.id

      $http.get 'employee/myteam/'+ $scope.accountId,cache:true
      .success (data) ->
        if data
          console.log data
          $scope.myteams = data
          $scope.selectedTeam = data[0].teamId
          formService.getForm($scope.selectedTeam.id)
          .then (res) ->
            form = res.data[0]
            console.log form
            if(form)
              $scope.form = form
            
            else
              formZero.type = "employee"
              formZero.teamId = $scope.selectedTeam.id
              $scope.form = formZero
        else
          console.log 'error man'


    $scope.addKRA = () ->
      newKRA = {

          kpis: [
            {
              'name': ''
              'description': ''
              'goal': 0
              'weight': 0
            }
          ]
          weight: 0
          tmp: {}
          name: ''
          description: ''
      }
      console.log newKRA
      $scope.form.kras.push(newKRA)

    $scope.deleteKRA = (i)->
      $scope.form.kras.splice(i,1)
      console.log "deleting "+i


    $scope.addKPI = (kra)->
      newKPI = {
        'name': ''
        'description': ''
        'goal': 0
        'weight': 0
      }
      kra.kpis.push(newKPI)

    $scope.deleteKPI = (ev, kra, kpiI) ->

      console.log kra
      console.log kpiI
      confirm = $mdDialog.confirm()
        .content("Deleting : "+kra.name+" - "+kra.kpis[kpiI].name)
        .ariaLabel('Lucky day')
        .title('Are you sure you want to delete this KPI?')
        .targetEvent(ev)
        .ok("I'm Sure")
        .cancel('Not Really')

      console.log $mdDialog.confirm
      $mdDialog.show(confirm).then( 
        ()->
          kra.kpis.splice(kpiI, 1)

        ,
        ()->
          
        )

    $scope.saveForm = ()->
      console.log "Saving form"
      delete $scope.form.id
      # console.log $scope.form.id
      formService.saveForm $scope.form
      .then (data) ->
        console.log "in FormCtrl - saveForm"
        console.log data

        $scope.editForm = false



    return
]





