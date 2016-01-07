module.exports =
  newEmployee: (req,res) ->
    accountId = req.param 'id'
    # console.log 'new'
    Notification.find({type:'New Employee',done:false,receiver: accountId})
    .populate 'sender'
    .exec (err,data) ->
      if data
        # console.log data
        res.json data

  newEvalRequest: (req,res) ->
    console.log 'newEvalRequest'
    accountId = req.param 'id'
    Notification.find({type:'Member Evaluation Request',done:false, receiver: accountId})
    .exec (err,data) ->
      if data
        console.log data

  # evalRequest: (req,res) ->
    # console.log 'eval request'
    # accountId = req.param 'id'
    # # EvaluationSchedule.find({status: 'waiting for confirmation',done: false})
    # # .populate 'sender'
    # # .exec (err,data) ->
    # #   if data
    # #     console.log 'eval data',data
    # #     res.json data
    # Notification.find({type:'Member Evaluation Request', receiver: accountId, done:false})
    # .exec (err,data) ->
    #   if data
    #     console.log 'mem eval',data
    #     data.forEach (res) ->
    #       console.log 'res',res
    #       EvaluationSchedule.find({type:'member',status:'pending', teamId:res.sender})
    #       .exec (err,data) ->
    #         if data
    #           console.log 'finallll data', data
    #     # res.json data


  update: (req,res) ->
    id = req.param 'id'
    Notification.update id, {done: true}
    .exec (err,data) ->
      if data
        console.log data
        res.json data


