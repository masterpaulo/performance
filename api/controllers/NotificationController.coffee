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
        # i = 0
        # async.eachSeries data, (item,callback) ->
        #     console.log 'start'
        #     if item
        #       async.setImmediate ->
        #         Team.findOne item.scheduleId.teamId
        #         .exec (err,result) ->
        #           if result
        #             data[i].teamName = result.name
        #             console.log 'inside findone',data
        #             i++
        #             if data.length is i
        #               callback data
        #     # console.log 'end',item
        #     # callback(data)
        #   , (err,result) ->
        #     console.log 'finalllll',err,result
        #     callback null,result


        data.forEach (d,key) ->
          Team.findOne d.scheduleId.teamId
          .exec (err,result) ->
            if result
              # console.log 'inside findone',result
              data[key].teamName = result.name
              if (key+1) is data.length
                # console.log 'key+1',key

                callback null,data
        # setTimeout () ->
        #   console.log 'should be after resssss'
        #   callback(null,data)
        # ,1000

    ], (err,result) ->
      if result
        # console.log 'result newEvalRequest', result
        res.json result



  update: (req,res) ->
    notifId = req.param 'notifId'
    evalStatus = req.param 'evalStatus'
    Notification.update notifId, {done: true}
    .exec (err,data) ->
      async.parallel [
        (callback) ->
          EvaluationSchedule.update data.scheduleId, {status:evalStatus}
          .exec (err,d) ->
            if d
              Team.findOne d[0].teamId
              .exec (err,data) ->
                d[0].teamName =  data.name
                callback null, d[0]
        (callback) ->
          newNotif =
            sender: data[0].receiver
            receiver: data[0].sender
            scheduleId: data[0].scheduleId

          newNotif.type = if evalStatus is 'active' then 'Member Evaluation Request Granted' else 'Member Evaluation Request Declined'
          console.log '2nd callback notif', newNotif
          Notification.create newNotif
          .exec (err,result) ->
            console.log err,result
            callback null,result

      ],
      (err,results) ->
        console.log 'notifi 101', results
        res.json results



  employeeNotif: (req,res) ->
    id = req.param 'id'
    Notification.find {receiver: id}
    .where {or:[
      {type:'Member Evaluation Request Granted'}
      {type:'Member Evaluation Request Declined'}
      {type:'Team Leader Evaluation'}
      ]}
    .populate 'scheduleId'
    .exec (err,data) ->
      if data
        console.log 'message',data
        res.json data

  # memberEvalReqConfirmation: (req,res) ->
  #   return




