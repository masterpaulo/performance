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

  removeMember: (req,res) ->
    data = JSON.parse req.params.all().data

    console.log data.accountId,data.teamId
    # console.log typeof data

    Teammember.destroy {accountId:data.accountId,teamId:data.teamId}
    .exec (err,data) ->
      if err
        console.log err
      if data
        console.log data
        console.log 'success deleting from backend'
        res.json data

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

  getStructure: (req,res) ->
    console.log teamId = req.param 'id'

    getParent = (team, structure, next)->

      if team
        Team.findOneById team
        .then (team) ->
          if !structure
            structure = [ team ]

          if team.parent
            Team.findOneById team.parent
            .exec (err,data)->
              if err
                console.log err
              else if data
                console.log "Showing parent"
                console.log data.parent
                data.child = JSON.parse JSON.stringify structure
                structure = [data]
                console.log "showing structure"
                console.log structure
                getParent data.id, structure, getParent
                return data
          else
            console.log "No parent"
            res.json structure
      else
        console.log "no team"
        res.json structure

    getChildren = (teamId, family, path) ->
      if teamId
        Team.findOneById teamId
        .then (team) ->

          if !family
            family = [ team ]
            path.push 0
          Team.find {parent:team.id}
          .then (childTeams)->
            console.log path
            console.log "children count: "+childTeams.length
            console.log family
            if childTeams.length
              console.log childTeams
              temp = family
              path.forEach (index) ->
                pointer = temp[index]
                # delete temp ==============================================TODO
                temp = pointer
                console.log "showing pointer"
                console.log temp
              temp.child = childTeams
              childTeams.forEach (childTeam, i)->
                path.push i
                getChildren childTeam.id, family, JSON.parse JSON.stringify path

            else
              console.log "No more children"
              console.log "RESPONES ==========================================="
              console.log family
              return null


    path = []
    getChildren teamId, null, path
    # getParent teamId, null, getParent




    # teamId = req.param 'id'
    # # console.log 'info now'
    # Team.find
