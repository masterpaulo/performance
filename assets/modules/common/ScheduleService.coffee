
scheduleService = ($http,$q,$timeout) ->

  return  {
    activeSchedules: () ->
      $http.get 'evaluationschedule/active'
      .success (data) ->
        return data

    create: (newSched) ->
      $http.post 'evaluationschedule/create', newSched
      .success (data) ->
        return data

    delete: (schedId) ->
      $http.delete 'evaluationschedule/delete/' + schedId
      .success (data) ->
        return data

    checkForExist: (arr,newArr) ->
      return $q (resolve,reject) ->
        $timeout () ->
          console.log 'checking'
          found = false
          # arr = $scope.activeSchedules
          i = 0
          while (i < arr.length)
            # console.log arr[i]
            # console.log newSched
            if arr[i].teamId.id is newArr.teamId and arr[i].type is newArr.type and arr[i].done is false
              found = true


              break
            i++
          if found
            resolve(found)
          else
            reject(found)
          # resolve found = false
        , 1000

  }

app.factory 'scheduleService', scheduleService





