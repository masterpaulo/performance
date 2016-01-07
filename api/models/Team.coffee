module.exports = {
  connection: 'mongo'

  attributes: {
    name: 'STRING'
    description: 'STRING'
    supervisor:
      model: 'account'
    members:
      collection: 'teammember'
      via: 'teamId'
    parentId:
      model: "team"

  }
}
