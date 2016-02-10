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
    $scope.teamName = scopes.teamName
    $scope.teamSearch = ""
    $scope.editForm = 0;


    $scope.selectedTeam = '';
    $scope.teams = []
    $scope.forView = false
    $scope.validKRA = false
    $scope.validEvaluation = false
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

        console.log $scope.supervisorEvaluation = data

    else
      $http.get 'form/evaluatemember', {params: $scope.data}
      .success (data) ->
        # c=0
        data.forEach (result,key) ->
          # console.log typeof data[key].kras
          data[key].kras = result.formId.kras if data[key].kras is undefined
          if (key+1) is data.length
            console.log $scope.memberEvaluations = data

    $scope.cancel = ->
      console.log 'cancelling'
      $mdDialog.cancel()
      return
    $scope.submitEvaluation = (evaluation,i) ->
      console.log evaluation
      # console.log evalId,kras,i
      # console.log data
      console.log updateEval =
        evaluationId: evaluation.id
        evaluator: $scope.data.evaluator
        scheduleId: $scope.data.scheduleId
        kras: evaluation.kras
        score: evaluation.score
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

    console.log $scope.totalScore= 0

    $scope.hide = () ->
      $mdDialog.hide()
    # $scope.memberSelected = (i) ->
    #   console.log i, 'kkkkkkkkkkkkkkkkkkkkkkkk'
    $scope.$watch 'memberEvaluations', (evaluations) ->
      # evaluations = evals



      console.log 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
      i = 0
      while(i <evaluations.length)
        console.log 'iiii', i
        kras = evaluations[i].kras
        k = kraCount=0

        overAllScore=0


        while(k < kras.length)
          console.log 'kkkk',k
          kpis = kras[k].kpis
          l = scoreKRA= totalKPI = 0
          validKRA = false
          # console.log overAllScore, 'first'
          while(l < kpis.length)
            console.log 'llll', l
            # kpis[l]
            # console.log kpis[l].score
            if kpis[l].score is null
              evaluations[i].valid = false
              return
              # $scope.validEvaluation = false
              # console.log 'nullllllllllllllllllllllllllllllllllllllllllllll'
              # break
            if kpis[l].score && kpis[l].score > -1 && kpis[l].score < kpis[l].goal
              # console.log 'valid'
              validKRA = true
              kpiScore = (kpis[l].score / kpis[l].goal) * (kpis[l].weight)
              totalKPI += kpiScore
            else
              # console.log kpis[l].score, 'current'
              # console.log 'invalid'
              totalKPI = 0
              # $scope.validEvaluation = false
              evaluations[i].valid = false
              validKRA = false
              # break
            l++
            # console.log l,'lllll'
            if kpis.length is l and validKRA
              console.log 'inside the equal length'
              scoreKRA = (totalKPI/100) * evaluations[i].kras[k].weight
              overAllScore += scoreKRA
              # console.log 'current overl', overAllScore
              kraCount++
          k++
          if kraCount is kras.length
            console.log 'final score', overAllScore
            $scope.validEvaluation = true
            console.log evaluations[i].score = overAllScore
            evaluations[i].valid = true

        i++

        # while(k < kras.length)
        #   kpis = kras[k]
        #   l = 0
        #   while(l < kpis.length)

      # evaluations.forEach (evaluation,i) ->
      #   # console.log evaluation
      #   # console.log evaluation, 'joke ra'
      #   totalScore=0
      #   evaluation.kras.forEach (kra,k) ->
      #     addKPIS = aveKPIS= validKRACount= scoreKRA=0
      #     kra.kpis.forEach (kpi,i) ->
      #       console.log 'in'
      #       console.log kpi

      #       if kpi.score
      #         validKRACount++

      #       if kra.kpis.length is validKRACount
              # console.log kra.kpis.length, validKRACount
            # console.log addKPIS, aveKPIS, validKRACount, scoreKRA
            # if kpi.score > kpi.goal || kpi.score < 0 || !kpi.score
            #   console.log 'score is invalid'
            #   $scope.validKRA = false
            #   $scope.validEvaluation = false

            # else if kpi.score
            #   console.log 'score is valid'
            #   $scope.validKRA = true
            #   divKPI = (kpi.score / kpi.goal) * (kpi.weight/100)
            #   addKPIS += divKPI
            #   validKRACount++

            # if kra.kpis.length is validKRACount and $scope.validKRA
            #   console.log kra.kpis.length,validKRACount, $scope.validKRA
              # console.log 'kra score', scoreKRA = (addKPIS * 100) / (100/evaluations[i].kras[k].weight)
              # # console.log 'weight', evaluations[i].kras[k].weight
              # evaluations[i].kras[k].score = scoreKRA
              # console.log totalScore += scoreKRA
              # validEvalCount++

          # if evaluation.kras.length is validEvalCount and $scope.validKRA
          #   console.log $scope.totalScore = totalScore
          #   $scope.validEvaluation = true
          #   evaluations[i].score = $scope.totalScore
            # console.log evaluation

    , true





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





