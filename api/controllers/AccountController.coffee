module.exports =
  list: (req,res) ->

    Account.find()
    .sort 'lastname ASC'
    .exec (err,data) ->
      if err
        console.log err
      if data
        # console.log data
        res.json data
  findById: (req,res) ->
    accountId = req.param 'id'
    Account.findOne accountId
    .exec (err,data) ->
      if err
        console.log 'error',err
      else
        res.json data


  #   # HR
  # hr: (req,res) ->
  #   UserRole.find {roleId: '1'}
  #   .exec (err,data) ->
  #     if data
  #       console.log data
  #       res.json data


