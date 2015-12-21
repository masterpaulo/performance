module.exports = {
  connection: 'mongo'

  attributes: {
    name: 'STRING'
    description: 'STRING'
    supervisor:
      type: 'STRING'
      model: 'account'
    members:
      collection: 'teammember'
      via: 'teamId'
    parentId:
      model: "team"

  }
}
