module.exports =
  myteam: (req,res) ->
    accountId = req.param 'id'

    Teammember.find({accountId: accountId})
    .populate 'teamId'
    .exec (err,data) ->
      if err
        console.log err
      if data
        # console.log data
        res.json data

  members: (req,res) ->
    teamId = req.param 'id'
    Teammember.find({teamId:teamId})
    .populate 'accountId'
    .populate 'teamId'
    .exec (err,data) ->
      if err
        console.log err
      if data
        # console.log data
        res.json data

  info: (req,res) ->
    id = req.param 'id'
    Account.find(id)
    .exec (err,data) ->
      if data
        # console.log data
        res.json data

