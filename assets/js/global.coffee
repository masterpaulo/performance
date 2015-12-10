app.config [
  "$mdThemingProvider"
  ($mdThemingProvider)->

    $mdThemingProvider.theme "default"
    .primaryPalette 'light-blue', 
      "default" : "900"
      "hue-1" : "600"
      "hue-2" : "700"
      "hue-3" : "800"

    .accentPalette 'deep-purple', 
      "default" : "500"
      "hue-1" : "300"
      "hue-2" : "700"
      "hue-3" : "800"

    .backgroundPalette 'grey',
      "default" : "50"
      "hue-1" : "100"
      "hue-2" : "200"
      "hue-3" : "800"



    $mdThemingProvider.theme "darken"
    .primaryPalette 'red', 
      "default" : "500"
      "hue-1" : "100"
      "hue-2" : "600"
      "hue-3" : "700"

    .accentPalette 'blue'
    .backgroundPalette 'grey',
      "default" : "800"
      "hue-1" : "300"
      "hue-2" : "600"
      "hue-3" : "900"

    .dark()
]