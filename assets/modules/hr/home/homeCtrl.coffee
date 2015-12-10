app.controller "HomeCtrl", [
  '$scope'
  '$sails'
  '$http'
  '$filter'
  '$interval'
  '$mdSidenav'
  '$mdDialog'
  ($scope, $sails, $http, $filter, $interval, $mdSidenav, $mdDialog) ->

    # Create the data table.
    data = new (google.visualization.DataTable)
    data.addColumn 'string', 'Topping'
    data.addColumn 'number', 'Score'
    data.addRows [
      ['Philippines', 90]
      ['India', 67]
      ['California', 45]
    ]
    # Set chart options
    options = 
      'title': 'Sample Pie Chart'
      'width': 400
      'height': 300
    # Instantiate and draw our chart, passing in some options.
    chart = new (google.visualization.PieChart)(document.getElementById('chart_div'))
    chart.draw data, options



    options2 = 
      'title': 'Motivation Level Throughout the Day'
      'width': 450
      'height': 300
    chart2 = new (google.visualization.ColumnChart)(document.getElementById('bar_chart'))
    chart2.draw data, options2

    $scope.toggleSidenav = (menuId) ->
      $mdSidenav(menuId).toggle()
      return

    $scope.test = ()->
      console.log "Testing"
      return


    return
]