'use strict';

let externalDependencies = ['ngAnimate', 'ngCookies', 'ngSanitize', 'ui.router', 'ui.bootstrap', 'angular-hal'];

let components =  ['sentinel.components.navbar',
  'sentinel.config',
  'sentinel.components.statuses',
  'sentinel.components.pstatuses',
  'sentinel.components.statuses.edit',
  'sentinel.components.statuses.new',
  'sentinel.components.auth',
  'sentinel.components.authResource',
  'sentinel.components.userService',
  'sentinel.components.auth.interceptor',
  'sentinel.components.statusResource',
  'sentinel.components.main',
  'sentinel.components.pstatuses.detail',
  'sentinel.components.metric.resource',
  'sentinel.components.metric.directive'
  ];


angular.module('externalDependencies', externalDependencies);
angular.module('components', components);

var app = angular.module('sentinel', ['externalDependencies', 'components']);

app
.config(function ($stateProvider, $urlRouterProvider, $httpProvider) {
  $httpProvider.interceptors.push('AuthInterceptor');
  $stateProvider
  .state('admin', {
    abstract: true,
    url: '/admin',
    templateUrl: 'app/main/main.html',
    controller: ($scope, $rootScope, UserService) => {
      UserService.setUserFromApi();
      $rootScope.loaded = false;
      $scope.userService = UserService;
    }
  })
  .state( 'admin.statusList', {
    url: '/statuses/list',
    templateUrl: 'app/components/admin/statuses/statuses.html'
  })
  .state('admin.statusEdit', {
    url: '/edit/:id',
    templateUrl: 'app/components/admin/statuses/edit.html',
    controller: 'EditStatusCtrl'
  })
  .state('admin.statusCreate', {
    url: '/create',
    templateUrl: 'app/components/admin/statuses/new.html',
    controller: 'NewStatusCtrl'
  })
  .state('signin', {
    url: '/signin',
    templateUrl: 'app/components/admin/auth/login.html',
    controller: 'AuthCtrl'
  })
  .state('statuses', {
    abstract: true,
    url: '/statuses',
    templateUrl: 'app/main/main.html',
    controller: ($rootScope, $state) => {
      if ($state.current.name && $state.current.url == "/list/:id") {
        $rootScope.domain = $state.params.id;
      }
      $rootScope.loaded = false;
    }
  })
  .state('statuses.list', {
    url: '/list/:id',
    templateUrl: 'app/components/statuses/pstatuses.html'
  })
  .state('statuses.detail', {
    url: '/status/:id',
    templateUrl: 'app/components/statuses/pstatus.detail.html'
  });

  $urlRouterProvider.otherwise('/admin/statuses/list');
});
