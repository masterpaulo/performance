# callouts =
#   welcome: [message: "Welcome to MeWe please login to start using the app"]
#   wrongAccess: [message: "Wrong email or password"]
#   banned: [message: "email has been banned from accessing this app"]

# roles = [
#   {id:1, view:'employee'}
#   {id:2, view:'hr'}

# ]


###
 configure this later together with grunt task to get user data configuration from an external json file like users.json
###
module.exports.render = (req, res) ->
  base = req.headers.host
  # req.session.passport.user.roles = []
  # req.session.passport.user.currentRole = 0


  # # console.log req.session.passport

  # #get user session data from passport startegy
  user_data = req.session.passport.user if req.session.passport
  # # console.log 'user_data'
  # console.log user_data
  # console.log "User access from: "+ user_data.email if user_data
  if user_data
    console.log 'in user_data'
    console.log user_data

    if req.session.passport.user.currentRole is '1'
      res.view "hr",
        base: base,
        user: JSON.stringify user_data
    else if req.session.passport.user.currentRole is '2'
      res.view "employee",
        base: base,
        user: JSON.stringify user_data






  else
    res.view "public",
      base: base
