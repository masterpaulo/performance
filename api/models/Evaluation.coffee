module.exports =
  connection: 'mongo'
  attributes: {
    evaluatee:
      model: 'account'
    evaluator:
      model: 'account'
    scheduleId:
      model: 'evaluationschedule'
    formId:
      model: 'form'
    kras:
      type:'array'
    rating:
      type: 'integer'
    status:
      type: 'boolean'
      defaultsTo: false




  }
