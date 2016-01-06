module.exports =
  list: (req,res) ->
    Team.find()
    .exec (err,data) ->
      if err
        console.log err
      if data
        res.json data


