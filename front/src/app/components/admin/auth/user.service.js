'use strict';

var user = angular.module('sentinel.components.userService', []);

class UserService {
   constructor(halClient, environmentConfig) {
     this.environmentConfig = environmentConfig;
     this.connected = false;
     this.resource  = halClient;
   }

   setUserFromApi() {
     return this.resource
       .$get(`${this.environmentConfig.api}/me`)
       .then((user) => {
         this.setUser(user);
       });
   }

   setUser(user) {
     this.email = user.email
     this.connected = true;
     this.domain = user.domain
   }

   unsetUser(user) {
     this.email = null
     this.connected = false;
   }

}

UserService.$inject = ['halClient', 'EnvironmentConfig'];

user
  .service('UserService', UserService);

export default UserService;
