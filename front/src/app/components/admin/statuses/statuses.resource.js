'use strict';

var statuses = angular.module('sentinel.components.statusResource', []);

class StatusResource {
   constructor(halClient, environmentConfig) {
     this.resource  = halClient;
     this.environmentConfig = environmentConfig;
   }

   getStatuses() {
     return this.resource
       .$get(this.environmentConfig.api + '/statuses');
   }

   getPublicStatuses(domain) {
     return this.resource
       .$get(`${this.environmentConfig.api}/public_statuses/${domain}`);
   }

   getStatus(id) {
     var url = this.environmentConfig.api + '/statuses/' + id;
     return this
       .resource
       .$get(url);
   }

   update(status, path) {
     return this.resource.$patch(path, null,  {
       check: {
         url: status.url,
         name: status.name,
         protocol: status.protocol,
         type: status.type,
         _id: status.id.$oid,
         description: status.description,
         expected_response: status.expected_response,
         verb: status.verb,
         visibility: status.visibility,
         params: status.params
       }
     });
   }

   save(status, path) {
     return this.resource.$post(path, null, {
       check: {
         url: status.url,
         name: status.name,
         protocol: status.protocol,
         type: status.type,
         description: status.description,
         expected_response: status.expected_response,
         verb: status.verb,
         params: status.params
       }
     });
   }
}

StatusResource.$inject = ['halClient', 'EnvironmentConfig'];

statuses
  .service('StatusResource', StatusResource);

export default StatusResource;

