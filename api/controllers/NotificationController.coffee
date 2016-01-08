async = require 'async'

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

#     async.waterfall([
#     function(callback) {
#         callback(null, 'one', 'two');
#     },
#     function(arg1, arg2, callback) {
#       // arg1 now equals 'one' and arg2 now equals 'two'
#         callback(null, 'three');
#     },
#     function(arg1, callback) {
#         // arg1 now equals 'three'
#         callback(null, 'done');
#     }
# ], function (err, result) {
#     // result now equals 'done'
# });


    console.log 'newEvalRequest'
    accountId = req.param 'id'
    # Notification.find {type: 'Member Evaluation Request', done:false,receiver:accountId}
    # .populate 'scheduleId'
    # .exec (err,data) ->
    #   if data
    #     data.forEach (d,key) ->
    #       Team.find d.scheduleId.teamId
    #       .exec (err,result) ->
    #         if result
    #           data[key].teamId = result
    async.waterfall [
      (callback) ->
        Notification.find {type: 'Member Evaluation Request', done: false, receiver: accountId}
        .populate 'scheduleId'
        .exec (err,data) ->
          if data
            callback(null,data)
      (data, callback) ->
        data.forEach (d,key) ->
          Team.findOne d.scheduleId.teamId
          .exec (err,result) ->
            if result
              console.log 'ressssssssssssss',result
              data[key].teamName = result.name
        console.log 'should be after resssss'
        callback(null,data)
    ], (err,result) ->
      res.json result

    # accountId = req.param 'id'
    # Notification.find({type:'Member Evaluation Request',done:false, receiver: accountId})
    # .exec (err,data) ->
    #   if data
    #     console.log data

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
    notifId = req.param 'notifId'
    evalStatus = req.param 'evalStatus'
    Notification.update notifId, {done: true}
    .exec (err,data) ->
      if data
        console.log 'notif success to true', data
        EvaluationSchedule.update data.scheduleId, {status:evalStatus}
        .exec (err,d) ->
          if d
            console.log 'eval uodate',d
            Team.findOne d[0].teamId
            .exec (err,data) ->
              console.log 'team found', data
              d[0].teamName =  data.name
              console.log 'updatinggggggggg',d[0]
              res.json d[0]



  message: (req,res) ->
    id = req.param 'id'
    Notification.find {receiver: id}
    .populate 'scheduleId'
    .exec (err,data) ->
      if data
        console.log 'message',data
        res.json data



