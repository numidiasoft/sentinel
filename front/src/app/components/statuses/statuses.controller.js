'use strict';

var statuses = angular.module('sentinel.components.statuses', []);

class StatusesCtrl {

  constructor($scope, statusResource) {
    var self = this;
    self.statusResource = statusResource;

    statusResource.getStatuses().then( (response) => {
      self.resource = response;
      $scope.statuses = response.statuses;
      $scope.loadMorePath = response.$href('self');
      $scope.currentPage = 2;
    });

    $scope.loadMore = function(page)  {
      self.resource
        .$get('self', { 'page': page }).then((response) => {
          $scope.currentPage += 1;
          $scope.statuses = $scope.statuses.concat(response.statuses);
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

StatusesCtrl.$inject =  ['$scope', 'StatusResource'];

statuses
  .controller('StatusesCtrl', StatusesCtrl);

export default StatusesCtrl;
