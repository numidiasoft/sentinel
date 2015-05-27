'use strict';

let externalDependencies = ['ngAnimate', 'ngCookies', 'ngSanitize', 'ui.router', 'ui.bootstrap', 'angular-hal'];

let components =  ['sentinel.components.navbar',
  'sentinel.config',
  'sentinel.components.statuses',
  'sentinel.components.statuses.edit',
  'sentinel.components.statuses.new',
  'sentinel.components.statusResource',
  'sentinel.components.main'
  ];


angular.module('externalDependencies', externalDependencies);
angular.module('components', components);

var app = angular.module('sentinel', ['externalDependencies', 'components']);

app
.config(function ($stateProvider, $urlRouterProvider) {
  $stateProvider
  .state('home', {
    url: '/',
    templateUrl: 'app/main/main.html',
    controller: 'MainCtrl'
  })
  .state('editStatus', {
    url: '/statuses/:id',
    templateUrl: 'app/components/statuses/edit.html',
    controller: 'EditStatusCtrl'
  })
  .state('newStatus', {
    url: '/statuses',
    templateUrl: 'app/components/statuses/new.html',
    controller: 'NewStatusCtrl'
  });


  $urlRouterProvider.otherwise('/');
});
