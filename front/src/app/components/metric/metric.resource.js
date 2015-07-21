'use strict';

var metrics = angular.module('sentinel.components.metric.resource', []);

class MetricResource {
   constructor(halClient, environmentConfig) {
     this.resource  = halClient;
     this.environmentConfig = environmentConfig;
   }

   getMetrics(statusId, options = {}) {
     var params = this._getParams(options)
     var url = `${this.environmentConfig.api}/metrics/${statusId}${params}`;
     return this
       .resource
       .$get(url);
   }

   _getParams(options) {
      var params = '';
      for(var k in options) {
        params += `${k}=${options[k]}&`;
      }
      if (params.length > 0 ) {
        params =`/?${params}`;
      }
      return params;
   }
}

MetricResource.$inject = ['halClient', 'EnvironmentConfig'];

metrics
  .service('MetricResource', MetricResource);

export default MetricResource;

