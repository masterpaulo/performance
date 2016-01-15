

formService = ($http) ->
	form = {}

	


	service = {
		getForm : () ->
			return $http.get 'form/get'

		saveForm : (form) ->
			$http.post 'form/save', form
				.success (data) ->
					console.log data
					return data


	}

	return service

	#############

	


app.factory "formService", formService

