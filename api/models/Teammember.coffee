module.exports = {
  connection: 'mongo'

  attributes: {
    accountId:
      type: "string"
      model: 'account'
    teamId:
      type: 'string'
      model: 'team'

  }
}
