
appService = ($http) ->

  return {
    # viewSwitcher: (roleId) ->
    #   $http.put 'view/switch/' + roleId
    #   .success (data) ->
    #     if data
    #       window.location.reload()

  }

app.factory 'appService', appService
