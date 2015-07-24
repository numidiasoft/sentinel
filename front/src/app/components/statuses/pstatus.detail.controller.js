'use strict';

var statusDetail = angular.module('sentinel.components.pstatuses.detail', []);

class PublicStatusDetailCtrl {
  constructor($scope, $stateParams, $rootScope,  StatusResource) {
    var self = this
    StatusResource.getPublicStatus($stateParams.id).then( (status) => {
      $rootScope.loaded = true;
      $scope.status = status;
    });
  }
}

PublicStatusDetailCtrl.$inject = ['$scope', '$stateParams', '$rootScope', 'StatusResource']

statusDetail.controller('PublicStatusDetailCtrl', PublicStatusDetailCtrl)


