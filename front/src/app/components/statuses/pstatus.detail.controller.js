'use strict';

var statusDetail = angular.module('sentinel.components.pstatuses.detail', []);

class PublicStatusDetailCtrl {
  constructor($scope, $stateParams, $rootScope,  StatusResource) {
    var self = this
    StatusResource.getStatus($stateParams.id).then( (status) => {
      console.log($rootScope.loaded);
      $rootScope.loaded = true;
      $scope.status = status;
    });
  }
}

PublicStatusDetailCtrl.$inject = ['$scope', '$stateParams', '$rootScope', 'StatusResource']

statusDetail.controller('PublicStatusDetailCtrl', PublicStatusDetailCtrl)


