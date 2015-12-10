module.exports =
  create: (req,res) ->
    # console.log 'creatinggggggg'
    # console.log req.body
    evaluation =
      date: req.body.date
      teamId: req.body.team
      type: req.body.type
      notes: req.body.notes
      evaluationLimit: req.body.evaluationLimit
    EvaluationSchedule.create(evaluation)
    .exec (err,data) ->
      if err
        console.log err
      if data
        console.log 'succcess creations'
        res.json data


  list: (req, res) ->
    EvaluationSchedule.find().populate('teamId')
    .exec (err,data) ->
      if err
        console.log err
      if data
        res.json data

