'use strict';

var statuses = angular.module('sentinel.components.pstatuses', []);

class PublicStatusesCtrl {

  constructor($scope, $stateParams, $rootScope, statusResource, userService) {
    var self = this;
    self.statusResource = statusResource;

    statusResource.getPublicStatuses($stateParams.id).then( (response) => {
      self.resource = response;
      $scope.statuses = response.statuses;
      $rootScope.loaded = true;
      $scope.hasNext = response.$has('next');
    });

    $scope.loadMore = function()  {
      self.resource
        .$get('next').then((response) => {
          $scope.statuses = $scope.statuses.concat(response.statuses);
          $scope.hasNext = response.$has('next');
          self.resource = response;
        });
    };

  }

  indexOf(array, element) {
    return array.map((item) => {
      return item.id.$oid;
    })
    .indexOf(element.id.$oid);
  }
}

PublicStatusesCtrl.$inject =  ['$scope', '$stateParams', '$rootScope', 'StatusResource', 'UserService'];

statuses
  .controller('PublicStatusesCtrl', PublicStatusesCtrl);

export default PublicStatusesCtrl;
