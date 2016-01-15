module.exports = 
  get : (req, res) ->
    Form.find(
      where : { type : 'supervisor' }
      sort: 'version DESC'
      limit: 1
    )
    .exec (err, data) ->
      if err
        console.log err
      else if data
        res.json data

  save : (req, res) ->
    form = req.body
    form.version++

    Form.create form
    .exec (err, data) ->
      if err
        console.log err
      else if data
        console.log data
        res.json data

    return
