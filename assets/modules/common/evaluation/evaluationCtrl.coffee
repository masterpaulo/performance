app.controller "EvaluateCtrl", [
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
  '$rootScope'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, formService,$rootScope) ->

    $scope.teamSearch = ""
    $scope.editForm = 0;

    $scope.selectedTeam = '';
    $scope.teams = []
    data = $rootScope.toEvaluate
    $http.get 'form/evaluatesupervisor', {params: data}
    .success (data) ->
      $scope.evaluationId = data.id
      # console.log 'data',data
      # console.log data.formId.id
      formService.getForm(data.formId.id)
      .success (data) ->
        # console.log "in FormCtrl"
        # console.log 'form',data

        # form = data.data[0]
        if data
          $scope.form = data

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

    $scope.submitEvaluation = (kras,evaluationId) ->
      console.log kras, evaluationId
      updateEval =
        kras: kras
        evaluationId: evaluationId

      $http.put 'form/submitevaluation', updateEval
      .success (data) ->
        if data
          console.log 'submittingggggggg', data




    # $scope.addKRA = () ->
    #   newKRA = {

    #       kpis: [
    #         {
    #           'name': ''
    #           'description': ''
    #           'goal': 0
    #           'weight': 0
    #         }
    #       ]
    #       weight: 0
    #       tmp: {}
    #       name: ''
    #       description: ''
    #   }
    #   console.log newKRA
    #   $scope.form.kras.push(newKRA)

    # $scope.deleteKRA = (i)->
    #   $scope.form.kras.splice(i,1)
    #   console.log "deleting "+i


    # $scope.addKPI = (kra)->
    #   newKPI = {
    #     'name': ''
    #     'description': ''
    #     'goal': 0
    #     'weight': 0
    #   }
    #   kra.kpis.push(newKPI)

    # $scope.deleteKPI = (ev, kra, kpiI) ->

    #   console.log kra
    #   console.log kpiI
    #   confirm = $mdDialog.confirm()
    #     .content("Deleting : "+kra.name+" - "+kra.kpis[kpiI].name)
    #     .ariaLabel('Lucky day')
    #     .title('Are you sure you want to delete this KPI?')
    #     .targetEvent(ev)
    #     .ok("I'm Sure")
    #     .cancel('Not Really')

    #   console.log $mdDialog.confirm
    #   $mdDialog.show(confirm).then(
    #     ()->
    #       kra.kpis.splice(kpiI, 1)

    #     ,
    #     ()->

    #     )

    # $scope.saveForm = ()->
    #   console.log "Saving form"
    #   delete $scope.form.id
    #   # console.log $scope.form.id
    #   formService.saveForm $scope.form
    #   .then (data) ->
    #     console.log "in FormCtrl - saveForm"
    #     console.log data

    #     $scope.editForm = false



    # return
]





