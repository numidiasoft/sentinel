'use strict';

var main =  angular.module('sentinel.components.main', []);

class MainCtrl {
  constructor ($scope) {
    $scope.date = new Date();
  }
}

MainCtrl.$inject = ['$scope'];

main
  .controller('MainCtrl', MainCtrl);

export default MainCtrl;
