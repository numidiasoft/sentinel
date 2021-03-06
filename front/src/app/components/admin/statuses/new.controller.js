'use strict';

var statuses = angular.module('sentinel.components.statuses.new', []);

class NewStatusCtrl {
  constructor($scope, $stateParams, $timeout, statusResource, environmentConfig) {
    var self = this;
    $scope.status = { verb: 'GET', type: 'auto'};

    $scope.save = function () {
      var path = environmentConfig.api + '/statuses';
      statusResource
        .save($scope.status, path)
        .then(() => {
          self.flash($scope, $timeout, 700);
        })
        .catch(() => {
          self.flash($scope, $timeout, 500, 'danger');
        });
    };

  }

  flash(scope, timeout, delay, type = 'success') {
    scope.updated = true;
    scope.type = type;

    timeout(() => {
      scope.updated = false;
    }, delay);
  }
}

NewStatusCtrl.$inject =  ['$scope','$stateParams', '$timeout', 'StatusResource', 'EnvironmentConfig'];

statuses
  .controller('NewStatusCtrl', NewStatusCtrl);

export default NewStatusCtrl;
