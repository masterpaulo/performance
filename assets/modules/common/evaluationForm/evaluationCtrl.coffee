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
  'scopes'
  'appService'
  'scheduleService'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog, $mdBottomSheet, $mdMedia, formService,$rootScope,scopes,appService,scheduleService) ->
    console.log $scope.teamId = scopes.teamId


    $scope.teamSearch = ""
    $scope.editForm = 0;

    $scope.selectedTeam = '';
    $scope.teams = []
    $scope.forView = false
    $scope.data = $rootScope.toEvaluate
    if $scope.data.evaluatee is 'supervisor'
      # console.log $scope.data.evaluatee
      $http.get 'form/evaluatesupervisor', {params: $scope.data}
      .success (data) ->
        # console.log data
        # $scope.evaluationId = data.id
        # console.log 'data',data
        # console.log data.formId.id
        # if data.status

        #   # console.log 'dataaaaaaaaaaaaaa',data.formId
        #   # console.log data.formId
        #   # form = {}
        #   form = data.formId
        #   form.kras = data.kras
        #   $scope.forView = true
        #   # console.log form
        #   # console.log $scope.form = form

        # else
        data.kras = data.formId.kras if data.kras is undefined
        $scope.supervisorEvaluation = data

    else
      $http.get 'form/evaluatemember', {params: $scope.data}
      .success (data) ->
        # c=0
        data.forEach (result,key) ->
          # console.log typeof data[key].kras
          data[key].kras = result.formId.kras if data[key].kras is undefined
          if (key+1) is data.length
            console.log $scope.memberEvaluations = data
        # $scope.memberEvaluations
        # console.log 'member forms',data
    # formService.getForm($scope.teamId)
    # .success (data) ->
    #   # console.log "in FormCtrl"
    #   # console.log 'form',data
    #   console.log 'dataaaa',data
    #   # form = data.data[0]
    #   if data
    #     $scope.form = data

    #   else
    #     form = {
    #       "kras" : [
    #         {
    #           "kpis" : [
    #             {
    #                 "name" : ""
    #                 "description" : ""
    #                 "goal" : 0
    #                 "weight" : 0
    #             }
    #           ]
    #           "weight" : 0
    #           "tmp" : {}
    #           "name" : ""
    #           "description" : ""
    #         },

    #       ],
    #       "type" : "supervisor"
    #       "status" : true
    #       "version" : 0
    #     }
    #     $scope.form = form
    # memberEvaluated = 0

    $scope.submitEvaluation = (evalId,kras,i) ->
      # console.log evalId,kras,i
      # console.log data
      console.log updateEval =
        evaluationId: evalId
        evaluator: $scope.data.evaluator
        scheduleId: $scope.data.scheduleId
        kras: kras
      # console.log updateEval
      $http.put 'form/submitevaluation', updateEval
      .success (data) ->
        if data
          console.log 'submittingggggggg', data
          if $scope.data.evaluatee is 'supervisor'
            $scope.hide()
            $scope.supervisorEvaluation.status = true
            appService.alert.success 'Supervisor Evaluation Success'
          else
            $scope.memberEvaluations[i].status = true
            appService.alert.success 'Member Evaluation Success'

          scheduleService.incrementCount data[0].scheduleId
            .success (data) ->
              console.log 'success updating schedule'


    $scope.hide = () ->
      $mdDialog.hide()




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





