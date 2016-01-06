module.exports = {
  connection: 'mongo'

  attributes: {
    date: 'string'
    teamId:
      model: "team"
    type:
      type: 'STRING'
      enum: ["member","supervisor"]
      defaultsTo: "member"
    notes:
      type: "string"

    evaluationCount:
      type: "integer"
      defaultsTo: 0
    evaluationLimit:
      type: "integer"
      defaultsTo: 0
    rating:
      type: "float"
      defaultsTo: 0
    done:
      type: "boolean"
      defaultsTo: false
    # archive:
    #   type: "boolean"
    #   defaultsTo: false
    status:
      type: 'string'
      enum: ['pending','cancelled','active','completed','archive']

    # evaluations:
    #   collections: "evaluation"
    #   via: "evaluationSchedule"
  }
}
