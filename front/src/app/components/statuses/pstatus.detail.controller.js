'use strict';

var statusDetail = angular.module('sentinel.components.pstatuses.detail', []);

class PublicStatusDetailCtrl {
  constructor($scope, $stateParams, StatusResource) {
    var self = this
    StatusResource.getStatus($stateParams.id).then( (status) => {
      $scope.status = status;
    });
  }
}

PublicStatusDetailCtrl.$inject = ['$scope', '$stateParams', 'StatusResource']

statusDetail.controller('PublicStatusDetailCtrl', PublicStatusDetailCtrl)


