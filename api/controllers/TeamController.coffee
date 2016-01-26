module.exports =
  list: (req,res) ->
    Team.find()
    .populate 'supervisor'
    .populate 'members'
    .sort 'name ASC'
    .exec (err,data) ->
      if err
        console.log err
      if data
        # console.log data

        res.json data

  get: (req,res) ->
    Team.findOneById req.param "id"
    .populate "members"
    .exec (err, data) ->
      if err
        console.log err
      else if data
        accountIds = data.members.map (member) ->
          return member.accountId
        Account.find {id:accountIds}
        .exec (err,accounts) ->
          if err
            console.log err
          else if accounts
            data.members = accounts
            #
            data.latestScore = 7
            #
            data.average = 100
            res.json data

  evaluator: (req,res) ->
    teamId = req.param 'id'
    # Team.findOne teamId
    # .populate 'm,'
    return






  create: (req, res) ->
    Team.create req.body
    .exec (err, data) ->
      if err
        console.log err
      else if data
        # console.log data
        res.json data

    return


  update: (req, res) ->
    console.log req.body
    id = req.body.id
    data = req.body.data
    Team.update id, data
    .exec (err, data) ->
      if err
        console.log err
      else if data
        # console.log data
        res.json data


  addMember: (req, res) ->
    console.log "showing new membership"
    # console.log req.body

    Teammember.create req.body
    .exec (err,data) ->
      if err
        console.log err
      else if data
        # console.log data
        res.json data

    return

  membersForEvaluation: (req,res) ->
    scheduleId = req.param 'id'
    Evaluation.find({scheduleId:scheduleId})
    .exec (err,data) ->
      if data
        res.json data

  setSupervisor: (req, res) ->

    console.log req.body
    supervisor = req.body
    Team.update(supervisor.team,{supervisor:supervisor.member})
    .exec (err, data) ->
      if err
        console.log err
      else if data
        res.json data

  membersInfo: (req,res) ->
    console.log data = req.params.all()
    team = JSON.parse data.team
    allMembers = []
    c = 0
    team.members.forEach (member,key) ->
      Account.findOne member.accountId
      .exec (err,data) ->
        if data
          # console.log 'membersinfo ',data
          team.members[key].accountId = data
          c++
          if c is team.members.length
            res.json team



    # teamId = req.param 'id'
    # # console.log 'info now'
    # Team.find




