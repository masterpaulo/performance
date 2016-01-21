

formService = ($http) ->
	form = {}

	


	service = {
		getForm : (teamId) ->
			query =
				params :
					'teamId' : teamId

			return $http.get 'form/get', query

		saveForm : (form) ->
			$http.post 'form/save', form
				.success (data) ->
					console.log data
					return data


	}

	return service

	#############

	


app.factory "formService", formService

