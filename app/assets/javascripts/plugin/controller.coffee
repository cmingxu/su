angular.module('building').controller 'main', ['$scope', '$http', '$interval', 'Entity', ($scope, $http, $interval, Entity) ->
  $scope.current_model = {}
  Entity.get {id: 1}, (data) ->
    console.log data

  $scope.bridge = (action, param) ->
    console.log 'bridge' + action
    window.location.href = "skp:" + action + "@" + param

  $scope.current_model_name_change = () ->
    $scope.bridge "current_model_name_change", $scope.current_model.name
]



