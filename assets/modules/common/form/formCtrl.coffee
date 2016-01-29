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
    $scope.$parent.routes = 'Form'
    $scope.teamSearch = ""
    $scope.editForm = 0;

    $scope.selectedTeam = '';
    $scope.teams = []
    $scope.form = {}
    $scope.errors = [
      {
        code:1
        msg:"Total KRA score is not equal 100"
        status: false
        target: null
      }
      {
        code:2
        msg:"Total KPI score is not equal 100"
        status: false

        target:null
      }
      {
        code:3
        msg:"KRAs must have a title"
        status: false

        target:null
      }
      {
        code:4
        msg:"KPIs must have a title"
        status: false

        target:null
      }
    ]
# <<<<<<< HEAD:assets/modules/hr/form/formCtrl.coffee
#     $scope.form = {}
#     $scope.form.kras = []
#     formService.getForm()
#     .then (data) ->
#       console.log "in FormCtrl"


#       form = data.data[0]
#       if(form)
#         $scope.form = form

#       else
#         form = {
#           "kras" : [
#             {
#               "kpis" : [
#                 {
#                     "name" : ""
#                     "description" : ""
#                     "goal" : 0
#                     "weight" : 0
#                 }
#               ]
#               "weight" : 0
#               "tmp" : {}
#               "name" : ""
#               "description" : ""
#             },

#           ],
#           "type" : "supervisor"
#           "status" : true
#           "version" : 0
#         }
#         $scope.form = form

# =======
    formZero = {

      kras : [
        {
          kpis : [
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
    $scope.loadForm = () ->
      if $scope.selectedTeam
        getForm = $scope.selectedTeam.id
        formType = 'member'
      else
        getForm = 'supervisor'
        formType = 'supervisor'

      formService.getForm(getForm)
      .then (res) ->
        form = res.data[0]
        console.log form
        if(form)
          $scope.form = form

        else
          formZero.type = formType
          formZero.teamId = getForm
          $scope.form = formZero
      return


    if $scope.$parent.userSession.currentRole == "1"
      $scope.selectedTeam = null
      $scope.loadForm()
    else
      $scope.accountId = $scope.userSession.id

      $http.get 'employee/myteam/'+ $scope.accountId,cache:true
      .success (data) ->
        if data
          console.log data
          $scope.myteams = []
          data.forEach (team)->
            # console.log team.team
            if team.teamId.supervisor == $scope.accountId
              $scope.myteams.push team.teamId

          $scope.selectedTeam = $scope.myteams[0]
          $scope.loadForm()

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
      console.log $scope.form
      formService.saveForm $scope.form
      .then (data) ->
        console.log "in FormCtrl - saveForm"
        console.log data

        $scope.editForm = false

    $scope.selectTeam = (i)->
      console.log i


      $scope.selectedTeam = $scope.myteams[i]
      $scope.loadForm()
      return

    $scope.$watch( 'form', (form)->
      # console.log form
      errors = [
        false
        false
        false
        false
      ]
      fail = false

      totalKras = 0
      if form
        form.kras.forEach (kra)->
          totalKpis = 0
          kra.kpis.forEach (kpi)->
            totalKpis += kpi.weight
          if totalKpis != 100
            errors[1] = true
          kra.totalKpi = totalKpis
          totalKras += kra.weight
        if totalKras != 100
          errors[0] = true

      errors.map (error, i)->
        $scope.errors[i].status = error
        if error
          fail = true

      $scope.form.fail = fail



    true
    )


    return

]




