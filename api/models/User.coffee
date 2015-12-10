module.exports = {
  connection: 'mongo'

  attributes: {
    provider: 'STRING'
    uid: 'STRING'
    name: 'STRING'
    email: 'STRING'
    firstname: 'STRING'
    lastname: 'STRING'
    photo: 'STRING'
    roles: 'array'
    currentRole: 'INTEGER'
  }
}
