'use strict';

var auth = angular.module('sentinel.components.auth.interceptor', []);
let self;

class AuthInterceptor {
  constructor($q, $injector) {
    self = this;
    self.injector = $injector;
    self.q = $q;
  }

  request(config) {
    return config;
  }

  requestError(rejection) {
    return self.q.reject(rejection);
  }

  responseError(rejection) {
    if (rejection.status === 401 || rejection.status === 403) {
      var state = self.injector.get('$state');
      state.transitionTo('signin');
    }
    return self.q.reject(rejection);
  }
}

auth.$inject = ['$q', '$injector'];

auth
  .service('AuthInterceptor', AuthInterceptor);

export default AuthInterceptor;
