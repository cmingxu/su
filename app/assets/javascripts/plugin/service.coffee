building = angular.module "building", ['ngResource']

building.constant 'CURRENT_USER', 'currentUser'

building.factory 'CurrentUser', ['$cookies', 'localStorageService', 'CURRENT_USER', ($cookies, localStorageService, CURRENT_USER) ->
    currentUser = {}

    currentUser.getUserInfo  = -> localStorageService.get(CURRENT_USER)
    currentUser.setUserInfo  = (userInfo) -> localStorageService.set(CURRENT_USER, userInfo)
    currentUser.isLogin      = -> $cookies.auth_token? and localStorageService.get(CURRENT_USER)?
    currentUser.destroy      = -> localStorageService.remove(CURRENT_USER)
    currentUser.hasAuthToken = -> $cookies.auth_token?

    currentUser.missingAccountInfo = ->
      currentUser = localStorageService.get(CURRENT_USER)
      (currentUser.email) is null

    currentUser
  ]

building.factory 'Entity', ($resource) ->
  $resource("/api/entities/:id", {id: '@id'})


