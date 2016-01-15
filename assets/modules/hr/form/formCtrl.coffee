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

    formService.getForm()
    .then (data) ->
      console.log "in FormCtrl"


      form = data.data[0]
      if(form)
        $scope.form = form
      
      else
        form = {
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
          "type" : "supervisor"
          "status" : true
          "version" : 0
        }
        $scope.form = form
      


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





