
passport = require 'passport'

module.exports =
  index: (req,res)->
    View.render(req,res)
    return

  logout: (req,res)->
    req.logout()
    res.redirect "/"
    return

  google: (req,res)->
    passport.authenticate('google', {
      failureRedirect: '/'
      scope: [ "https://www.googleapis.com/auth/plus.login", "https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email" ]
    }, (err, user) ->
      # console.log 'authcontroller',user

      # call to function reference: 'config.express.passport.serializeUser'
      req.logIn user, (err) ->
        if err
          console.log err
          res.view '500'
          return
        res.redirect '/'
        # res.json user
        return
      # res.redirect '/sample'

      return
    ) req, res


    return

  # list: (req,res) ->
  #   Account.find()
 #    .exec (err,data) ->
 #      if err
 #        console.log err
 #      if data
 #        # console.log data
 #        res.json data
