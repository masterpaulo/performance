module.exports =
  update: (req,res) ->
    console.log 'account',accountId = req.param 'accountId'
    console.log 'teamId',teamId = req.param 'teamId'
    Teammember.update {accountId:accountId, teamId:''},{teamId:teamId}
    .exec (err,data) ->
      if data
        console.log 'dataaa',data
        res.json data
    # Teammember.find {accountId: accountId}
    # .exec (err,data) ->
    #   if data
    #     console.log data
