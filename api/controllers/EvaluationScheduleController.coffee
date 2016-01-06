module.exports =
  create: (req,res) ->
    accountId = req.body.accountId
    teamId = req.body.teamId
    type = req.body.type
    date = req.body.date
    notes = req.body.notes
    # status = req.body.status
    evaluationLimit = req.body.evaluationLimit
    selectedMember = req.body.selectedMember

    # res.json error = 'rrrrrrrrrrrrrr'


    EvaluationSchedule.findOne({where:{teamId: teamId, type:type, done:false}, sort:'createdAt DESC'})
    .exec (err,data) ->
      if data
        console.log 'existing'
        res.json null
      else
        console.log 'ready to create'
        # console.log 'wala man'
        if req.body.type is 'supervisor'
          console.log 'supervisorrrrrrrrrrrrrrrr'
          evaluationSched =
            date: date
            teamId: teamId
            type: type
            notes: notes
            evaluationLimit: evaluationLimit
            status: 'active'
        else

          console.log 'memberrrrrrrrrrrrrr'

          UserRole.find({roleId:'1'})
          .exec (err,data) ->
            if data
              data.forEach (d) ->
                notif =
                  type: 'Member Evaluation Request'
                  sender: accountId
                  receiver: d.accountId
                Notification.create notif
                .exec (err,data) ->
                  if data
                    console.log 'success adding notif',data

          evaluationSched =
            date: date
            teamId: teamId
            type: type
            notes: notes
            evaluationLimit: evaluationLimit
            status: 'waiting for confirmation'

        EvaluationSchedule.create(evaluationSched)
          .exec (err,data) ->
            if err
              console.log err
            if data
              res.json data
              selectedMember.forEach (d) ->

                evaluation =
                  accountId: d
                  scheduleId: data.id

                Evaluation.create(evaluation)
                .exec (err,data) ->
                  if err
                    console.log err
                  if data
                    console.log data

  list: (req, res) ->
    teamId = req.param.id
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

