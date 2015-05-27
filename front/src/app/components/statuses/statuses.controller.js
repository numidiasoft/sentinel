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
  }

}

StatusesCtrl.$inject =  ['$scope', 'StatusResource'];

statuses
  .controller('StatusesCtrl', StatusesCtrl);

export default StatusesCtrl;
