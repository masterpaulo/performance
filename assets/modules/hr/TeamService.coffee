teamService = ($http) ->
	teams = []

	service = {
		listTeams : () ->
			return $http.get 'team/list'

		getTeam : (teamId)->
			$http.get 'team/get/'+teamId
	        .success (data) ->
	          	if data
		            console.log data
					return data

		addTeam : (team) ->
			$http.post 'team/create', team
			.then (newTeam) ->
				if newTeam
					return newTeam.data

		updateTeam : (teamId, team) ->
			$http.put 'team/update', {id:teamId, data:team }
			.then (newTeam) ->
				if newTeam
					return newTeam.data

		addMember : (membership) ->
			$http.post 'team/addMember', membership
			.then (newMembership) ->
				if newMembership
					return newMembership.data

		setSupervisor : (team, member) ->
			supervisor = 
				team : team.id
				member : member.id
			$http.put 'team/setSupervisor', supervisor
			.then (newTeam) ->
				if newTeam
					return newTeam.data

	}

	return service

	#############




app.factory "teamService", teamService

