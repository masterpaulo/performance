module.exports = 
  get : (req, res) ->
    id = req.param 'teamId'
    console.log id
    if id == "supervisor"
      Form.find(
        where : { type : 'supervisor' }
        sort: 'version DESC'
        limit: 1
      )
      .exec (err, data) ->
        if err
          console.log err
        else if data
          console.log "in supervisor"
          res.json data
    else
      Form.find(
        where : { teamId : id }
        sort : 'version DESC'
        limit : 1
      )
      .exec (err, data) ->
        if err
          console.log err
        else if data
          console.log "in employee"

          res.json data

  save : (req, res) ->
    form = req.body
    if !form.version
      form.version = 1
    
    form.version = form.version+1

    Form.create form
    .exec (err, data) ->
      if err
        console.log err
      else if data
        console.log data
        res.json data

    return
