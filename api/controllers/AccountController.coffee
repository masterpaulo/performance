module.exports =
  list: (req,res) ->
    # id = req.param 'id'
    # if id
    #   Account.find(id)
    #   .exec (err,data) ->
    #     if data
    #       res.json data
    # else
    Account.find()
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


