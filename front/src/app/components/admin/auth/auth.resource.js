'use strict';

var user = angular.module('sentinel.components.authResource', []);

class AuthResource {
   constructor(halclient, $state, environmentConfig) {
     this.resource  = halclient;
     this.environmentConfig = environmentConfig;
     this.state = $state;
   }

   signIn(user) {
     return this.resource.$post(this.environmentConfig.api + '/authentication', null, {
       email: user.email,
       password: user.password
     });
   }

   signOut() {
     this.resource
       .$del(this.environmentConfig.api + '/authentication')
       .then(() => {
          this.state.transitionTo('signin');
       });
   }
}

AuthResource.$inject = ['halClient', '$state', 'EnvironmentConfig'];

user
  .service('AuthResource', AuthResource);

export default AuthResource;

