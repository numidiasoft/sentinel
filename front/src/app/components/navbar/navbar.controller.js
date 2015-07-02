'use strict';

var navbar = angular.module('sentinel.components.navbar', []);

class NavbarCtrl {
  constructor ($scope, userService) {
    $scope.userService = userService;
  }
}

NavbarCtrl.$inject = ['$scope', 'UserService'];


navbar
  .controller('NavbarCtrl', NavbarCtrl);

export default NavbarCtrl;
