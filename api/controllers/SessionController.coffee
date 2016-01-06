roles = [
  {view:"home",id:null}
  {view:"hr",id:1}
  {view:"employee",id:2}
]
module.exports =
  types: (req, res) ->

    roleIds = roles.map (r)->
      return r.id
    # console.log 'roleIds',roleIds
    d = []
    userRoles = Copy req.session.passport.user.roles
    userRoles.forEach (r)->
      d.push {
        id: r
        name: roles[r].view
      }

    res.json d

  change: (req, res) ->
    id = req.param 'id'

    if id is '1'
      res.json req.session.passport.user.currentRole = '2'
    else
      res.json req.session.passport.user.currentRole = '1'


  check: (req, res) ->
    res.json req.session.passport.user

  token: (req, res) ->
    res.json req.session.passport.user.token
