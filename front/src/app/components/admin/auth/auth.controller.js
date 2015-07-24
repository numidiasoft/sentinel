'use strict';

var auth = angular.module('sentinel.components.auth', []);

class AuthCtrl {
  constructor($scope, $state, $rootScope,  $timeout, AuthResource, UserService) {
    $scope.user = {};
    var self = this;
    if ($state.current.name === 'signin') {
      $rootScope.loaded = true;
    }

    $scope.signin = function(user) {
      AuthResource.signIn(user).then((response) => {
        UserService.setUser(user);
        $rootScope.loaded = false;
        $state.transitionTo('admin.statusList');
      }).catch(function() {
        self.flash($scope, $timeout, 500);
      });
    };

    $scope.signout = function() {
      AuthResource.signOut();
      UserService.unsetUser()
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

AuthCtrl.$inject =  ['$scope', '$state', '$rootScope', '$timeout', 'AuthResource', 'UserService'];

auth
  .controller('AuthCtrl', AuthCtrl);

export default AuthCtrl;
