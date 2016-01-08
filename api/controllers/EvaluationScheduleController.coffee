async = require 'async'

module.exports =
  create: (req,res) ->
    accountId = req.body.accountId
    teamId = req.body.teamId
    type = req.body.type
    date = req.body.date
    notes = req.body.notes
    status = req.body.status
    # status = req.body.status
    evaluationLimit = req.body.evaluationLimit
    selectedMember = req.body.selectedMember

    evaluationSched =
      date: date
      teamId: teamId
      type: type
      notes: notes
      evaluationLimit: evaluationLimit
      status: status

    EvaluationSchedule.findOne({where:{teamId: teamId, type:type, done:false}, sort:'createdAt DESC'})
    .exec (err,data) ->
      if data
        console.log 'existing'
        res.json null
      else
        console.log 'ready to create'
        # console.log 'wala man'
        if req.body.type is 'supervisor'
          console.log 'evaluation for team leader'
          console.log evaluationSched
          EvaluationSchedule.create evaluationSched
          .exec (err,data) ->
            if data
              console.log 'success creating evaluation for team leader',data

              res.json data
              scheduleId = data.id
              Team.findOne teamId
              .populate 'members'
              .exec (err,data) ->
                if data
                  data.members.forEach (member) ->
                    # console.log 'memmmmmmmmmmber', member
                    notif =
                      sender: accountId
                      receiver: member.accountId
                      scheduleId: scheduleId
                    if data.supervisor is member.id
                      notif.type = "Schedule For Your Evaluation"
                    else
                      notif.type = "Team Leader Evaluation"
                      evaluation =
                        evaluatee: data.supervisor
                        evaluator: member.id
                        scheduleId: scheduleId
                      Evaluation.create evaluation
                      .exec (err,data) ->
                        if data
                          console.log 'success creating evaluation for tl'
                    Notification.create notif
                    .exec (err,data) ->
                      if data
                        console.log 'sucess notifications'


        else

          console.log 'request evaluation for members'
          EvaluationSchedule.create evaluationSched
          .exec (err,data) ->
            if data
              res.json data
              scheduleId = data.id
              UserRole.find {roleId:'1'}
              .exec (err,data) ->
                if data
                  data.forEach (d) ->
                    notif =
                      type: 'Member Evaluation Request'
                      sender: accountId
                      receiver: d.accountId
                      scheduleId: scheduleId
                    Notification.create notif
                    .exec (err,data) ->
                      if data
                        console.log 'success adding notifs for hr'

              selectedMember.forEach (d) ->
                evaluation =
                  evaluatee: d
                  evaluator: accountId
                  scheduleId: scheduleId

                Evaluation.create evaluation
                .exec (err,data) ->
                  if data
                    console.log 'success creating evaluation'


  list: (req, res) ->
    teamId = req.param 'id'
    if teamId
      EvaluationSchedule.find({teamId: teamId})
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

  active: (req,res) ->
    EvaluationSchedule.find {status:'active'}
    .populate 'teamId'
    .exec (err,data) ->
      if data
        res.json data

