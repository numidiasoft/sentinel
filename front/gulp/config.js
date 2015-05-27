'use strict';

var gulp = require('gulp');
var gulpNgConfig = require('gulp-ng-config');
var ngConstant = require('gulp-ng-constant');
var util = require('gulp-util');
var NODE_ENV = process.env.NODE_ENV || 'development';

module.exports = function(options) {
  var stream = gulp.src('config.yml');
  var dest = options.src;

  gulp.task('config', function () {
    stream
    .pipe(gulpNgConfig('sentinel.config', {
       environment: NODE_ENV,
       parser: 'yml'
     }))
    .pipe(gulp.dest(dest))
  });
}


