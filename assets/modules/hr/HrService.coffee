
hrService = ($http) ->
  return {
    findById: (accountId) ->
      $http.get 'account/findById/' + accountId
      .success (data) ->
        return data

    membersInfo: (team) ->
      $http.get 'team/membersInfo', params: {team:team}
      .success (data) ->
        return data


  }

app.factory 'hrService', hrService
