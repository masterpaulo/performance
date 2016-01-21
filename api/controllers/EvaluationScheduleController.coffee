async = require 'async'

module.exports =
  create: (req,res) ->
    accountId = req.body.accountId
    teamId = req.body.teamId
    type = req.body.type
    date = req.body.date
    notes = req.body.notes
    status = req.body.status
    evaluationLimit = req.body.evaluationLimit
    selectedMember = req.body.selectedMember

    evaluationSched =
      date: date
      teamId: teamId
      type: type
      notes: notes
      evaluationLimit: evaluationLimit
      status: status
    # console.log 'creating enw sched'
    async.parallel([
      (callback) ->
        Form.findOne where : { type : 'supervisor' }
        .exec (err,data) ->
          if data
            console.log 'findONE form for supervisor'
            callback null,data
      (callback) ->
        EvaluationSchedule.create evaluationSched
        .exec (err,data) ->
          if data
            console.log 'creating sched success'
            callback null,data
          # scheduleId = newEval.id

      ], (err,results) ->
        newEval = results[1]
        scheduleId = newEval.id
        if newEval.type is 'supervisor'
          Team.findOne newEval.teamId
          .populate 'members'
          .exec (err,data) ->
            if data
              i = 1

              # console.log 'success finding team',data
              data.members.forEach (member) ->
                console.log 'line 49 memberrrrrr',member
                # console.log 'memmmmmmmmmmber', member
                notif =
                  sender: accountId
                  receiver: member.accountId
                  scheduleId: scheduleId
                  type: "Team Leader Evaluation"

                evaluation =
                  evaluatee: data.supervisor
                  evaluator: member.accountId
                  scheduleId: scheduleId
                  formId: results[0].id
                # if data.supervisor is not member.id
                # console.log data.supervisor, member.accountId,data.members.length
                if data.supervisor isnt member.accountId
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
                      if data.members.length is i
                        console.log 'successssss'
                        res.json newEval
                  )

        else

          # console.log 'request evaluation for members'
          # EvaluationSchedule.create evaluationSched
          # .exec (err,data) ->
          #   if data
          #     res.json data
          # scheduleId = data.id
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
              console.log 'successssss'
              # console.log 'final results', results
              res.json newEval
            if err
              console.log 'error final results'
          )
      )
    # EvaluationSchedule.create evaluationSched
    # .exec (err,newEval) ->
    #   scheduleId = newEval.id

      # console.log 'success adding evalSched',data







    # if req.body.type is 'supervisor'
    #   # console.log 'evaluation for team leader'
    #   # console.log evaluationSched
    #   EvaluationSchedule.create evaluationSched
    #   .exec (err,data) ->
    #     if data
    #       # console.log 'success creating evaluation for team leader',data

    #       res.json data
    #       scheduleId = data.id
    #       Team.findOne teamId
    #       .populate 'members'
    #       .exec (err,data) ->
    #         if data
    #           data.members.forEach (member) ->
    #             # console.log 'memmmmmmmmmmber', member
    #             notif =
    #               sender: accountId
    #               receiver: member.accountId
    #               scheduleId: scheduleId
    #             if data.supervisor is member.id
    #               notif.type = "Schedule For Your Evaluation"
    #             else
    #               notif.type = "Team Leader Evaluation"
    #               evaluation =
    #                 evaluatee: data.supervisor
    #                 evaluator: member.id
    #                 scheduleId: scheduleId
    #               Evaluation.create evaluation
    #               .exec (err,data) ->
    #                 if data
    #                   console.log 'success creating evaluation for tl'
    #             Notification.create notif
    #             .exec (err,data) ->
    #               if data
    #                 console.log 'sucess notifications'


    # else

    #   console.log 'request evaluation for members'
    #   EvaluationSchedule.create evaluationSched
    #   .exec (err,data) ->
    #     if data
    #       res.json data
    #       scheduleId = data.id
    #       UserRole.find {roleId:'1'}
    #       .exec (err,data) ->
    #         if data
    #           data.forEach (d) ->
    #             notif =
    #               type: 'Member Evaluation Request'
    #               sender: accountId
    #               receiver: d.accountId
    #               scheduleId: scheduleId
    #             Notification.create notif
    #             .exec (err,data) ->
    #               if data
    #                 console.log 'success adding notifs for hr'

    #       selectedMember.forEach (d) ->
    #         evaluation =
    #           evaluatee: d
    #           evaluator: accountId
    #           scheduleId: scheduleId

    #         Evaluation.create evaluation
    #         .exec (err,data) ->
    #           if data
    #             console.log 'success creating evaluation'

  delete: (req,res) ->
    id = req.param 'id'
    EvaluationSchedule.destroy id
    .exec (err,data) ->
      if data[0].status is 'pending'
        console.log 'data',data
        Notification.destroy({scheduleId: id})
        .exec (err,data) ->
          if data
            res.json data
      else
        res.json data
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

  active: (req,res) ->
    EvaluationSchedule.find {status:'active'}
    .populate 'teamId'
    .exec (err,data) ->
      if data
        res.json data

  # submitEvaluation: (req,res) ->
  #   evalId = req.param 'id'

    # Evaluation.find evalId
    # .exec (err,data) ->
    #   if data
    #     res.json data

  # evaluationFind: () ->
  #   evalId = req.param 'id'
  #   Evaluation.find evalId
  #   .exec (err,data) ->
  #     if data
  #       res.json data

