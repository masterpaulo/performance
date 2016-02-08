
scheduleService = ($http,$q,$timeout) ->

  return  {
    allSchedules: () ->
      $http.get 'evaluationschedule/allSchedules', cache:true
      .success (data) ->
        return data

    create: (newSched) ->
      $http.post 'evaluationschedule/create', newSched
      .success (data) ->
        return data
      # .error (err) ->
      #   console.log err
      #   console.log 'not successful'
      #   return err

    delete: (schedId) ->
      $http.delete 'evaluationschedule/delete/' + schedId
      .success (data) ->
        return data

    findByTeam: (teamId) ->
      $http.get 'evaluationschedule/list/' + teamId
      .success (data) ->
        return data

    incrementCount: (schedId) ->
      # data =
      #   scheduleId:schedId
      #   newData: newData
      $http.put 'evaluationschedule/incrementCount/' + schedId
      .success (data) ->
        return data

    checkForExist: (arr,newArr) ->
      # console.log 'check for exist',arr.length
      return $q (resolve,reject) ->
        $timeout () ->
          console.log 'checking'
          found = false
          # arr = $scope.activeSchedules
          i = 0
          while (i < arr.length)
            # console.log arr[i]
            # console.log newSched
            if arr[i].teamId
              if arr[i].teamId.id is newArr.teamId and arr[i].type is newArr.type and arr[i].done is false
                found = true
                console.log 'nakitan'


                break
            i++

          console.log 'console',found,arr.length,i
          if found
            console.log 'exist'
            resolve(found)
          else
            console.log 'wala man'
            reject(found)
          # resolve found = false
        , 1000

    evaluationView: (scheduleId) ->
      $http.get 'evaluationschedule/evaluationView/' + scheduleId
      .success (data) ->
        return data

    editEvaluation: (scheduleId) ->
      $http.get 'evaluationschedule/editevaluation/'+scheduleId
      .success (data) ->
        return data
    editFinish: (sched) ->
      $http.put 'evaluationschedule/editFinish', params: sched
      .success (data) ->
        return data

  }

app.factory 'scheduleService', scheduleService





