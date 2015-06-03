'use strict';

var auth = angular.module('sentinel.components.auth', []);

class AuthCtrl {
  constructor($scope, $state, $timeout, AuthResource) {
    $scope.user = {};
    var self = this;

    $scope.signin = function(user) {
      AuthResource.signIn(user).then(() => {
        $state.transitionTo('statuses.list');
      }).catch(function() {
        self.flash($scope, $timeout, 500);
      });
    };

    $scope.signout = function() {
      AuthResource.signOut();
    };
  }

  flash(scope, timeout, delay, type = 'danger') {
    scope.updated = true;
    scope.type = type;

    timeout(() => {
      scope.updated = false;
    }, delay);
  }
}

AuthCtrl.$inject =  ['$scope', '$state', '$timeout', 'AuthResource'];

auth
  .controller('AuthCtrl', AuthCtrl);

export default AuthCtrl;
