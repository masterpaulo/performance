module.exports =
  get : (req, res) ->
# <<<<<<< HEAD
#     formId = req.param 'id'
#     # Form.find(
#     #   where : { type : 'supervisor' }
#     #   sort: 'version DESC'
#     #   limit: 1
#     # )
#     # .exec (err, data) ->
#     #   if err
#     #     console.log err
#     #   else if data
#     #     res.json data
#     Form.findOne formId
#     .exec (err,data) ->
#       if data
#         console.log 'form find'
#         res.json data
# =======
    id = req.param 'teamId'
    console.log id
    if id == "supervisor"
      Form.find(
        where : { type : 'supervisor' }
        sort: 'version DESC'
        limit: 1
      )
      .exec (err, data) ->
        if err
          console.log err
        else if data
          console.log "in supervisor"
          res.json data
    else
      Form.find(
        where : { teamId : id }
        sort : 'version DESC'
        limit : 1
      )
      .exec (err, data) ->
        if err
          console.log err
        else if data
          console.log "in employee"

          res.json data

  save : (req, res) ->
    form = req.body
    if !form.version
      form.version = 1

    form.version = form.version+1

    Form.create form
    .exec (err, data) ->
      if err
        console.log err
      else if data
        console.log data
        res.json data

    return

  evaluatesupervisor: (req,res) ->
    console.log 'evaluatesupervisor'
    console.log evaluate = req.allParams()

    Evaluation.findOne {scheduleId: evaluate.scheduleId, evaluator:evaluate.evaluator}
    .populate 'formId'
    .populate 'evaluatee'
    .populate 'evaluator'
    .exec (err,data) ->
      if data
        console.log 'evaluate', data
        res.json data


    return

  evaluatemember: (req,res) ->
    console.log 'evaluate member'
    console.log evaluate = req.allParams()
    Evaluation.find {scheduleId: evaluate.scheduleId, evaluator:evaluate.evaluator}
    .populate 'evaluatee'
    .populate 'formId'
    .populate 'evaluator'
    .exec (err,data) ->
      if data
        console.log 'evaluate', data
        res.json data

  submitEvaluation: (req,res) ->
    newEval = req.allParams()
    # console.log 'newEval',newEval
    console.log 'neweassdrr',newEval
    search =
      id:newEval.evaluationId,
      evaluator:newEval.evaluator
      scheduleId: newEval.scheduleId

    Evaluation.update search, {kras:newEval.kras, rating:newEval.score,status:true}
    .exec (err,data) ->
      if data
        console.log 'SUCCCEESSSS',data
        EvaluationSchedule.findOne data[0].scheduleId
        .exec (err,ev) ->
          if ev
            console.log 'evaluationsched', ev
            # if ev.rating
            #   ev.rating = (ev.rating +=data.rating)/2
            # else
            if ev.rating
              ev.rating = (ev.rating+=data[0].rating)/2
            else
              ev.rating = data[0].rating
            ev.save (err,result) ->
              if result
                console.log 'result', result

        res.json data



