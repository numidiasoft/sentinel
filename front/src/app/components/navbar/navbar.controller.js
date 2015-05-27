'use strict';

var navbar = angular.module('sentinel.components.navbar', []);

class NavbarCtrl {
  constructor ($scope) {
    $scope.date = new Date();
  }
}

NavbarCtrl.$inject = ['$scope'];


navbar
  .controller('NavbarCtrl', NavbarCtrl);

export default NavbarCtrl;
