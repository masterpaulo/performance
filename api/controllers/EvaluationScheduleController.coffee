async = require 'async'
array = require 'lodash/array'

module.exports =
  create: (req,res) ->
    accountId = req.body.accountId
    teamName = req.body.teamName
    teamId = req.body.teamId
    type = req.body.type
    date = req.body.date
    notes = req.body.notes
    status = req.body.status
    evaluationLimit = req.body.evaluationLimit
    console.log 'member',selectedMember = req.body.selectedMember


    evaluationSched =
      date: date
      teamId: teamId
      type: type
      notes: notes
      evaluationLimit: evaluationLimit
      status: status
    # console.log 'creating enw sched'
    async.waterfall([
      (callback) ->
        if type = 'supervisor'
          Form.findOne where : { type : evaluationSched.type }
          .sort 'version DESC'
          .exec (err,data) ->
            if data
              console.log 'findONE form for supervisor',data
              callback null,data
            else
              console.log 'missing form'
              # console.log err
              res.json err
        else
          Form.findOne where : { type : evaluationSched.type, teamId: evaluationSched.teamId }
          .sort 'version DESC'
          .exec (err,data) ->
            if data
              console.log 'findONE form for supervisor',data
              callback null,data
            else
              # console.log err
              # console.log 'missing form'
              res.json err
      (arg1, callback) ->
        if arg1
          EvaluationSchedule.create evaluationSched
          .exec (err,data) ->
            if data
              console.log 'creating sched success'
              data.formId = arg1.id
              callback null,data

            else
              console.log 'missing form'
          # scheduleId = newEval.id

    ], (err,results) ->
      # console.log results
      if err
        res.json err
      # if err
      #   console.log 'error man'
      if results
        console.log 'success'
        newEval = results
        # console.log 'newEval',newEval = results[1]

        scheduleId = newEval.id
        if newEval.type is 'supervisor'
          Team.findOne newEval.teamId
          .populate 'members'
          .exec (err,data) ->
            if data
              i = 1

              # console.log 'success finding team',data
              selectedMember.forEach (member,key) ->
                console.log 'line 49 memberrrrrr',member
                # console.log 'memmmmmmmmmmber', member
                notif =
                  sender: accountId
                  receiver: member
                  scheduleId: scheduleId
                  type: "Supervisor Evaluation"

                evaluation =
                  evaluatee: data.supervisor
                  evaluator: member
                  scheduleId: scheduleId
                  formId: results.formId
                  # status: false
                # if data.supervisor is not member.id
                # console.log data.supervisor, member.accountId,data.members.length
                # if data.supervisor isnt member.accountId
                  # console.log 'is not'
                async.parallel([
                  (callback) ->
                    console.log 'evaluation',evaluation
                    Evaluation.create evaluation
                    .exec (err,data) ->
                      if data
                        # console.log 'success eval'
                        callback null,'success'
                  (callback) ->
                    console.log 'notif',notif

                    Notification.create notif
                    .exec (err,data) ->
                      if data
                        # console.log 'success notif'
                        callback null,'success'
                ], (err,results) ->
                  if results
                    i++
                    # console.log i,data.members.length
                    if selectedMember.length is (key+1)
                      console.log 'successssss'
                      res.json newEval
                )

        else

          console.log 'request evaluation for members'
          # EvaluationSchedule.create evaluationSched
          # .exec (err,data) ->
          #   if data
          #     scheduleId = data.id
          async.parallel([
            (callback) ->
              UserRole.find {roleId:'1'}
              .exec (err,data) ->
                if data
                  i = 0
                  data.forEach (d) ->
                    notif =
                      type: 'Member Evaluation Request'
                      sender: accountId
                      receiver: d.accountId
                      scheduleId: scheduleId
                    Notification.create notif
                    .exec (err,newNotif) ->
                      if newNotif
                        i++
                        if data.length is i
                          # console.log 'success notif'
                          callback null,'success'
                        # console.log 'success adding notifs for hr'
            (callback) ->
              # console.log selectedMember, selectedMember.length
              c = 0
              selectedMember.forEach (d) ->
                evaluation =
                  evaluatee: d
                  evaluator: accountId
                  scheduleId: scheduleId
                  formId: results.formId
                # console.log 'creating new eval', evaluation
                Evaluation.create evaluation
                .exec (err,data) ->
                  if data
                    c++
                    if selectedMember.length is c
                      # console.log 'success evaluation'
                      callback null,'success'
                    # console.log 'success creating evaluation'
          ], (err,results) ->
            if results
              console.log 'successssss',results
              # console.log 'final results', results
              res.json newEval
            if err
              console.log 'error final results'
              res.json err
          )

    )



  delete: (req,res) ->
    id = req.param 'id'
    EvaluationSchedule.destroy id
    .exec (err,data) ->
      if data[0].status is 'pending' or data[0].status is 'active'
        console.log 'data',data
        async.parallel([
          (callback) ->
            Notification.destroy({scheduleId: id})
            .exec (err,data) ->
              if data
                callback(null,data)
          (callback) ->
            Evaluation.destroy({scheduleId:id})
            .exec (err,data) ->
              if data
                callback(null,data)

          ], (err,results) ->
            if results
              console.log 'success overall delete'
              res.json results
            )

  list: (req, res) ->
    teamId = req.param 'id'
    if teamId
      EvaluationSchedule.find({teamId: teamId})
      .populate 'teamId'
      .exec (err,data) ->
        if data
          res.json data

    else
      EvaluationSchedule.find().populate('teamId')
      .exec (err,data) ->
        if err
          console.log err
        if data
          res.json data

  allSchedules: (req,res) ->
    EvaluationSchedule.find({where:
      or:[{
        status: 'active'
        },{
        status: 'complete'
        },{
        status: 'archive'
        }]
      })

    .populate 'teamId'
    .exec (err,data) ->
      if data
        res.json data

  incrementCount: (req,res) ->
    console.log scheduleId = req.param 'id'
    # d = req.allParams().params
    # console.log d
    # console.log d
    # console.log typeof d
    # console.log d.scheduleId
    # console.log

    EvaluationSchedule.findOne scheduleId
    .exec (err,data) ->
      if data
        console.log 'zzz',data
        data.evaluationCount++

        if data.evaluationCount is data.evaluationLimit
          data.done = true
          data.status = 'complete'
          newNotif =
            scheduleId: data.id

          # Notification.create {newNotif}
          # .exec (err,data) ->
          #   if data
          #     console.log 'success notif'

          if data.type is 'supervisor'
            newNotif.type = 'Supervisor Evaluation is Finished'
          else
            newNotif.type = 'Member Evaluation is Finished'

          UserRole.find {roleId:'1'}
          .exec (err,data) ->
            if data
              data.forEach (d) ->
                newNotif.receiver = d.accountId
                Notification.create newNotif
                .exec (err,data) ->
                  if data
                    console.log 'success notif'


        data.save (err,data) ->
          if data
            console.log 'succccess updatingggg',data
            res.json data


  evaluationView: (req,res) ->
    console.log scheduleId = req.param 'id'
    Evaluation.find {scheduleId:scheduleId}
    .populate 'evaluator'
    .populate 'evaluatee'
    .exec (err,data) ->
      if data
        console.log 'evaluationview', data
        res.json data

  editEvaluation: (req,res) ->
    schedId = req.param 'id'
    async.parallel([
      (callback) ->
        async.waterfall([
          (callback) ->
            EvaluationSchedule.findOne schedId
            .exec (err,data) ->
              callback(null,data)
          (arg1,callback) ->
            evaluation = Copy arg1;
            Team.findOne arg1.teamId
            .populate 'supervisor'
            .populate 'members'
            .exec (err,team) ->
              if team
                evaluation.teamId = team
                callback(null,evaluation)

          (arg1, callback) ->
            evaluation = Copy arg1
            evaluation.teamId.members.forEach (member,key) ->
              Account.findOne member.accountId
              .exec (err,acc) ->
                if acc
                  evaluation.teamId.members[key].accountId = acc
                  setTimeout () ->
                    if evaluation.teamId.members.length is (key+1)
                      callback(null,evaluation)
                  , 100
        ],(err,result1) ->
          if result1
            # console.log 'result1',results
            callback(null,result1)
        )
      (callback) ->
        selected = []
        Evaluation.find {scheduleId: schedId}
        .exec (err,data) ->
          if data
            data.forEach (mem,key) ->
              selected.push mem.evaluator
              if data.length is (key+1)
                callback(null,selected)

      ],(err,final) ->
        if final
          # console.log 'final na jud ni', final
          # console.log final.length
          results = Copy final[0]
          results.selected = final[1]
          # final[0].selectedEvaluator = final
          console.log 'last results',results
          res.json results

        )
  editFinish: (req,res) ->
    console.log 'edit finish'
    console.log req.body
    sched = req.params.all().params
    console.log sched.selected

    if sched.selectedEdit
      Evaluation.find {scheduleId:sched.id}
      .exec (err,data) ->
        if data
          tempArr = []
          data.forEach (d) ->
            tempArr.push d.evaluator
            console.log tempArr
          console.log 'newId',newId = array.difference sched.selected, tempArr
          console.log 'delId',delId = array.difference tempArr, sched.selected
          async.parallel [
            (callback) ->
              EvaluationSchedule.update sched.id, {date: sched.date,notes: sched.notes, evaluationLimit:sched.selected.length}
              .exec (err,data) ->
                if data
                  callback null,data

            (callback) ->
              if newId.length
                newId.forEach (n,k) ->
                  newEval =
                    evaluatee: data[0].evaluatee
                    evaluator: n
                    formId: data[0].formId
                    scheduleId: data[0].scheduleId
                  Evaluation.create newEval
                  .exec (err,result) ->
                    if data
                      # console.log 'successss adding', data

                      newNotif =
                        receiver: result.evaluator
                        scheduleId: result.scheduleId
                        type: 'Supervisor Evaluation'
                      Notification.create newNotif
                      .exec (err,data) ->
                        if data
                          console.log 'ssccess adding notifs',data
                  if newId.length is (k+1)
                    callback null,'success adding evaluation and notifs'
              else
                callback null,'no to add'
            (callback) ->
              if delId.length
                delId.forEach (del,key) ->
                  # console.log 'sched and evaluator', sched.id, del
                  Evaluation.destroy {scheduleId: sched.id,evaluator: del}
                  .exec (err,data) ->
                    if data
                      # console.log 'success deleting',data
                      Notification.destroy {scheduleId:sched.id, receiver: del}
                      .exec (err,data) ->
                        if data
                          console.log 'success deleting notifs'


                    # else
                    #   console.log 'error',err
                    if delId.length is (key+1)
                      callback(null,'success deleting evaluation and notifs')
              else
                callback null,'no to delete'




          ], (err,result) ->
            if result
              console.log 'overall result',result
              res.json result

