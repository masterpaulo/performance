module.exports =
  list: (req,res) ->
    Account.find()
    .exec (err,data) ->
      if err
        console.log err
      if data
        # console.log data
        res.json data
