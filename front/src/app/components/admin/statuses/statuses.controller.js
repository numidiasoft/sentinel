'use strict';

var statuses = angular.module('sentinel.components.statuses', []);

class StatusesCtrl {

  constructor($scope, $rootScope, statusResource) {
    var self = this;
    self.statusResource = statusResource;

    statusResource.getStatuses().then((response) => {
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

    $scope.destroy = function(status) {
      self.status = status;
      self.resource
        .$del('statuses/delete', { id: status.id.$oid }).then(() => {
          var index = self.indexOf($scope.statuses, self.status);
          $scope.statuses.splice(index, 1);
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

StatusesCtrl.$inject =  ['$scope', '$rootScope', 'StatusResource'];

statuses
  .controller('StatusesCtrl', StatusesCtrl);

export default StatusesCtrl;
