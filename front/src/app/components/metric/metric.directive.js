'use strict';

var metrics = angular.module('sentinel.components.metric.directive', []);
let self;

class MetricDirective {
   constructor(halClient, EnvironmentConfig, MetricResource) {
     this.restrict = 'E';
     this.templateUrl = 'app/components/metric/metric.html';
     this.metricResource = MetricResource;
     self = this;
   }

   link(scope, element, attr) {
     var deregisterWatch = scope.$watch('status', (newVal, oldValue) => {
       if (typeof newVal === 'undefined') return;
       self.metricResource.getMetrics(newVal.id.$oid, {
        agregation: 'minutes',
        type: attr.type,
        since: 'hour'
       }).then((response) => {
         scope.data = JSON.parse(JSON.stringify(response));
         self.metricGraphic(scope.data, attr, element);
       });
     });
   }

   metricGraphic(json, attr, element) {
     var data = MG.convert.date(json, 'date', '%Y-%m-%dT%H:%M:%SZ');
     MG.data_graphic({
       title: attr.title,
       description: attr.description,
       data: data,
       full_width: true,
       height: 250,
       target: element.find('div')[0],
       x_accessor: "date",
       y_accessor: attr.type,
     });
   }

   static directiveFactory(halClient, EnvironmentConfig, MetricResource){
     MetricDirective.instance = new MetricDirective(halClient, EnvironmentConfig, MetricResource);
     return MetricDirective.instance;
   }
}

MetricDirective.directiveFactory.$inject = ['halClient', 'EnvironmentConfig', 'MetricResource'];

metrics
  .directive('sentinelMetric', MetricDirective.directiveFactory);

export default MetricDirective;

