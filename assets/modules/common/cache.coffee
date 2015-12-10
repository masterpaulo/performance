app.factory 'Cache',[
  "$cacheFactory"
  ($cacheFactory)->
    $httpDefaultCache = $cacheFactory.get '$http'

    cache =
      cache: $httpDefaultCache
      invalidate: (key)->
        $httpDefaultCache.remove key
      get: (key)->
        return angular.fromJson $httpDefaultCache.get(key)[1]
      put: (key,value)->
        $httpDefaultCache.put key,value
    return cache
]

app.service "CacheManager",[
  "Cache"
  (C)->
    ###
      bind this to a local $scope property

      register its location eg: TeamsCtrl

      and register the ids and keys
    ###
    cacheDir = {}
    ###
    cacheDir = {
      GroupCtrl:{
        id:value
      }
    }
    ###
    cmInstance =
      groupName:null
      register: (id,key)->
        cacheDir[@groupName][id] = key
        return @
      reset: (id,params)->
        gp = id.split "."

        groupName = @groupName
        
        if gp.length is 2
          groupName = gp[0]
          id = gp[1]
        console.log cacheDir[groupName]
        if cacheDir[groupName]
          key = cacheDir[groupName][id]

          if params
            for nkey of params
              prop = ":"+nkey
              key = key.replace prop,params[nkey]
          C.invalidate key
        return @
      resetAll:(groupName)->

        group = groupName or @groupName
        if cacheDir[group]
          for nkey of cacheDir[group]
            l = cacheDir[group][nkey].split ":"
            if l.length is 1
              C.invalidate nkey
        return @

      purge: ->
        for gp of cacheDir
          @resetAll gp
        return @

    CM =
      init: ( groupName )->
        
        cacheDir[groupName] = {} if !cacheDir[groupName]
        cmNew = angular.copy cmInstance
        cmNew.groupName = groupName

        return cmNew

    return CM

]