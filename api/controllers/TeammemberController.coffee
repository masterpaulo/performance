module.exports =
  create: (req,res) ->
    data =
      accountId: req.param 'accountId'
      teamId: req.param 'teamId'
    Teammember.create data
    .exec (err,data) ->
      if data
        res.json data

