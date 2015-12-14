module.exports =
  list: (req,res) ->
    Team.find()
    .exec (err,data) ->
      if err
        console.log err
      if data
        console.log data
       
        res.json data

  get: (req,res) ->
    Team.findOneById req.param "id"
    .exec (err, data) ->
      if err
        console.log err
      else if data
        data.members = [
          "Lee Sin"
          "Teemo"
          "Yasuo"
          "Darius"
          "Diana"
        ]

        data.latestScore = 7 + (data.name.length / 2)

        data.average = 100 / data.name.length
        res.json data

      
  create: (req, res) ->
    console.log req.body
    return
