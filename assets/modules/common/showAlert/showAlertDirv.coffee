app.factory "Alert",[
  "$rootScope"
  ($rootScope)->

    Alert =
      show: (config)->
        $rootScope.$broadcast "ALERT",config
        return
      good: (config)->
        config.type = "good"
        @show config
      bad: (config)->
        config.type = "bad"
        @show config
      action: (config)->
        config.type = "action"
        @show config

    return Alert
]
app.controller "AlertHolderCtrl",[
  "$scope"
  "$interval"
  "Alert"
  ($s,$i,A)->
    $s.alerts = []
    $s.$on "ALERT",(event,args)->
      args.start = new Date()
      $s.alerts.push args
      return
    $i ->
      if $s.alerts.length
        now = new Date()
        indexes = []
        $s.alerts.forEach (a,i)->
          diff = now - a.start
          indexes.push i if diff > 3000 and !a.hover
        indexes.forEach (idx)->
          $s.alerts.splice idx,1
    ,2000

    return
]
app.directive "alertHolder",[
  ->
    return {
      restrict:"E"
      template:JST["common/showAlert/showAlert.html"]()
      replace:true
      scope:
        position:"@"
      controller:"AlertHolderCtrl"
    }
]