

formService = ($http) ->
	form = {}




	service = {
		getForm : (formId) ->
			return $http.get 'form/get/' + formId

		saveForm : (form) ->
			$http.post 'form/save', form
				.success (data) ->
					console.log data
					return data


	}

	return service

	#############




app.factory "formService", formService

