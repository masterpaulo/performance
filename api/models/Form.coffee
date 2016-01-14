module.exports =
  connection: 'mongo'
  attributes:
    teamId:
      type: 'string'
      model: 'Team'

    default:
      type: 'boolean'
      defaultsTo: false
    kra:
      type: 'array'

    type:
      type: 'string'
      enum: ['member','supervisor']
      defaultsTo: 'member'


