module.exports =
  connection: 'mongo'
  attributes:
    type:
      type: 'string'
      enum: ['New Employee'
      'Member Evaluation Request'
      'Member Evaluation Request Granted'
      'Member Evaluation Request Declined'
      # 'Member Evaluation'
      'Supervisor Evaluation'
      'Member Evaluation is Finished'
      'Supervisor Evaluation is Finished'
      ]
      defaultsTo: 'New Employee'
    comment:
      type: 'string'
    sender:
      model: 'account'
    receiver:
      model: 'account'
    scheduleId:
      model: 'evaluationschedule'
    done:
      type: 'boolean'
      defaultsTo: false

