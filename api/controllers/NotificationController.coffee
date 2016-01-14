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

    console.log 'newEvalRequest'
    accountId = req.param 'id'

    async.waterfall [
      (callback) ->
        Notification.find {type: 'Member Evaluation Request', done: false, receiver: accountId}
        .populate 'scheduleId'
        .exec (err,data) ->
          if data
            callback(null,data)
      (data, callback) ->
        # sample = [{age:23},{age:23},{age:23},{age:23},]
        i = 0
        async.eachSeries data, (item,callback) ->
            console.log 'start'
            if item
              async.setImmediate ->
                Team.findOne item.scheduleId.teamId
                .exec (err,result) ->
                  if result
                    data[i].teamName = result.name
                    console.log 'inside findone',data
                    i++
            console.log 'end',item
              # console.log 'item',item
            callback(data)
          , (err,result) ->
            console.log 'finalllll',err,result
            console.log 'success'
            return

        # data.forEach (d,key) ->
        #   Team.findOne d.scheduleId.teamId
        #   .exec (err,result) ->
        #     if result
        #       console.log 'ressssssssssssss',result
        #       data[key].teamName = result.name
        # setTimeout () ->
        #   console.log 'should be after resssss'
        #   callback(null,data)
        # ,1000

    ], (err,result) ->
      if result
        console.log 'result newEvalRequest', result
        res.json result



  update: (req,res) ->
    notifId = req.param 'notifId'
    evalStatus = req.param 'evalStatus'
    Notification.update notifId, {done: true}
    .exec (err,data) ->
      if data
        # console.log 'notif success to true', data
        EvaluationSchedule.update data.scheduleId, {status:evalStatus}
        .exec (err,d) ->
          if d
            # console.log 'eval update',d
            Team.findOne d[0].teamId
            .exec (err,data) ->
              # console.log 'team found', data
              d[0].teamName =  data.name
              # console.log 'updatinggggggggg',d[0]
              res.json d[0]



  message: (req,res) ->
    id = req.param 'id'
    Notification.find {receiver: id}
    .populate 'scheduleId'
    .exec (err,data) ->
      if data
        # console.log 'message',data
        res.json data



