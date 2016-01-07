app.directive 'switch', [
  '$http'

  ($http) ->
    # Runs during compile
    {
      restrict: 'E'
      template: JST["common/switchView/switchView.html"]()
      replace: true
      scope:
        position:"@"
      controller: ($scope,$element,$attrs)->
        $scope.roles = []
        # $scope.currentRole = 0
        # get all roles available for this user and assign it to $scope.roles
        $http.get "/session/types"
        .success (roles)->
          $scope.roles = roles
          return

        $http.get "/session/check"
        .success (data) ->
          if data
            # console.log data
            $scope.currentRole = data.currentRole

        # set new active view in the session and refresh
        $scope.change = (roleId)->
          $http.put "/session/change/"+roleId
          .success (status)->
            document.location = '/' if status
          return
        return
    }
]
