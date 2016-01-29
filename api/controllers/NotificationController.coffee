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

    accountId = req.param 'id'
    console.log 'starting newEvalRequest', accountId


    async.waterfall [
      (callback) ->
        Notification.find {type: 'Member Evaluation Request', done: false, receiver: accountId}
        .populate 'scheduleId'
        .exec (err,data) ->
          if data.length
            console.log 'in data'
            callback(null,data)
          else
            console.log 'in err'
            res.json err
            # callback(null,error)

      (data, callback) ->
        # console.log data,callback
        # if data
        data.forEach (d,key) ->
          Team.findOne d.scheduleId.teamId
          .exec (err,result) ->
            if result
              # console.log 'inside findone',result
              data[key].teamName = result.name
              if (key+1) is data.length
                # console.log 'key+1',key
                console.log 'finding nemo',data
                callback null,data
          # callback null,null

    ], (err,result) ->
      console.log 'errr,res',err,result
      if result
        # console.log result
        console.log 'result newEvalRequest', result
        res.json result



  update: (req,res) ->
    notifId = req.param 'notifId'
    evalStatus = req.param 'evalStatus'
    console.log 'update',notifId,evalStatus
    Notification.update notifId, {done: true}
    .exec (err,data) ->
      if data
        console.log 'notif',data
        async.parallel [
          (callback) ->
            EvaluationSchedule.update data[0].scheduleId, {status:evalStatus}
            .exec (err,d) ->
              if d
                console.log 'success change eval', d
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
    .where {done:false,or:[
      {type:'Member Evaluation Request Granted'}
      {type:'Member Evaluation Request Declined'}
      {type:'Team Leader Evaluation'}
      ]}
    .populate 'scheduleId'
    .exec (err,data) ->
      if data
        console.log 'message',data
        res.json data

  read: (req,res) ->
    notifId = req.param 'id'

    Notification.update notifId, {done:true}
    .exec (err,data) ->
      if data
        res.json data



