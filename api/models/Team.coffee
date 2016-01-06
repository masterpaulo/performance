module.exports = {
  connection: 'mongo'

  attributes: {
    name: 'STRING'
    description: 'STRING'
    supervisor:
      model: 'account'
    teammembers:
      collection: 'teammember'
      via: 'teamId'
    parentId:
      model: "team"

  }
}
