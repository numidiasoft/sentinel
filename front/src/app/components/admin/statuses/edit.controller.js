'use strict';

var statuses = angular.module('sentinel.components.statuses.edit', []);

class EditStatusCtrl {
  constructor($scope, $rootScope, $stateParams, $timeout, statusResource) {
    var self = this;
    statusResource.getStatus($stateParams.id).then( (response) => {
      $scope.status = angular.copy(response);
      $rootScope.loaded = true;


      $scope.update = function (status) {
        statusResource
          .update(status, response.$href('statuses'))
          .then(() => {
            self.flash($scope, $timeout, 500);
          })
          .catch(() => {
            self.flash($scope, $timeout, 500, 'danger');
          });
      };
    });
  }

  flash(scope, timeout, delay, type = 'success') {
    scope.updated = true;
    scope.type = type;
    timeout(() => {
      scope.updated = false;
    }, delay);
  }
}

EditStatusCtrl.$inject =  ['$scope', '$rootScope', '$stateParams', '$timeout', 'StatusResource'];

statuses
  .controller('EditStatusCtrl', EditStatusCtrl);

export default EditStatusCtrl;
