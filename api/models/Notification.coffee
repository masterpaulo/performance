module.exports =
  connection: 'mongo'
  attributes:
    type:
      type: 'string'
      enum: ['New Employee','Member Evaluation Request']
      defaultsTo: 'New Employee'
    comment:
      type: 'string'
    sender:
      model: 'account'
    receiver:
      model: 'account'
    evalschedId:
      model: 'evaluationschedule'
    done:
      type: 'boolean'
      defaultsTo: false

