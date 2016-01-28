
appService = ($http, $mdToast) ->

  return {
    alert: {
      success: (msg) ->
        $mdToast.show(
          $mdToast.simple(msg)
            # .textContent('Simple Toast!')
            .theme("success-toast")
            .position('top right')
            .hideDelay(5000)
        );
      error: (msg) ->
        $mdToast.show(
          $mdToast.simple(msg)
            # .textContent('Simple Toast!')
            .theme("error-toast")
            .position('top right')
            .hideDelay(5000)
        );
    }
    checkForExist: (arr,findId) ->
      i = 0
      while i<arr.length
        if arr[i].id is findId
          console.log 'already exist in list'
          return true
          break
        i++

    # viewSwitcher: (roleId) ->
    #   $http.put 'view/switch/' + roleId
    #   .success (data) ->
    #     if data
    #       window.location.reload()

  }

app.factory 'appService', appService
