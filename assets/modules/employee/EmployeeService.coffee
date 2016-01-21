employeeService = ($http) ->

  return {
    myteam: (accountId) ->
      $http.get 'employee/myteam/' + accountId, cache:true
      .success (data) ->
        return data

    teammembers: (teamId) ->
      $http.get 'employee/members/' + teamId, cache:true
      .success (data) ->
        return data



  }


app.factory 'employeeService', employeeService
