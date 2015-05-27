'use strict';

describe('controllers', function(){
  var scope;

  beforeEach(module('sentinel'));

  beforeEach(inject(function($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should define date', inject(function($controller) {
    expect(scope.awesomeThings).toBeUndefined();

    $controller('MainCtrl', {
      $scope: scope
    });

    expect(angular.isDate(scope.date)).toBeTruthy();
    expect(scope.date).toBeDefined();
  }));
});
