teamService = ($http) ->
	teams = []

	service = {
		listTeams : () ->
			$http.get 'team/list'
			.success (data) ->
				return data
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

		removeMember : (accountId, teamId) ->
			console.log 'removing', accountId,teamId

			data =
				accountId: accountId
				teamId: teamId
			$http.delete 'team/removeMember/',params: {data}
			.then (data) ->
				console.log 'success deleting', data
				return data

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

