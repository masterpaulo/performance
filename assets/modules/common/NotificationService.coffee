notificationService = () ->
  return {
    # memberEvalReqConfirmation: (sender,receiver,status) ->
    #   $http.get 'notification/memberEvalReqConfirmation'

  }



app.factory 'notificationService', notificationService
