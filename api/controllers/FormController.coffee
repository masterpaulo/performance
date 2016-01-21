module.exports =
  get : (req, res) ->
    formId = req.param 'id'
    # Form.find(
    #   where : { type : 'supervisor' }
    #   sort: 'version DESC'
    #   limit: 1
    # )
    # .exec (err, data) ->
    #   if err
    #     console.log err
    #   else if data
    #     res.json data
    Form.findOne formId
    .exec (err,data) ->
      if data
        console.log 'form find'
        res.json data
  save : (req, res) ->
    form = req.body
    form.version++

    Form.create form
    .exec (err, data) ->
      if err
        console.log err
      else if data
        console.log data
        res.json data

    return

  evaluatesupervisor: (req,res) ->
    console.log evaluate = req.allParams()
    console.log evaluate.evaluator
    console.log evaluate.scheduleId

    Evaluation.findOne {scheduleId: evaluate.scheduleId, evaluator:evaluate.evaluator}
    .populate 'formId'
    .exec (err,data) ->
      if data
        console.log 'evaluate', data
        res.json data


    return

  submitEvaluation: (req,res) ->
    newEval = req.allParams()

    # console.log newEval
    Evaluation.update newEval.evaluationId, {kras:newEval.kras, status:true}
    .exec (err,data) ->
      if data
        console.log 'SUCCCEESSSS',data


