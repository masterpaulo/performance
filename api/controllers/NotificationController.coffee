module.exports =
  newEmployee: (req,res) ->
    console.log 'new'
    Notification.find({type:'New Employee',done:false})
    .populate 'sender'
    .exec (err,data) ->
      if data
        console.log data
        res.json data

  evalRequest: (req,res) ->
    console.log 'eval request'
    EvaluationSchedule.find({status: 'waiting for confirmation',done: false})
    .populate 'sender'
    .exec (err,data) ->
      if data
        console.log 'eval data',data
        res.json data


  update: (req,res) ->
    id = req.param 'id'
    Notification.update id, {done: true}
    .exec (err,data) ->
      if data
        console.log data
        res.json data


