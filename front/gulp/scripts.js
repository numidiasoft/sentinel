'use strict';

var gulp = require('gulp');
var browserSync = require('browser-sync');

var $ = require('gulp-load-plugins')();

module.exports = function(options) {
  function webpack(watch, callback) {
    var webpackOptions = {
      watch: watch,
      module: {
        preLoaders: [{ test: /\.js$/, exclude: /node_modules/, loader: 'jshint-loader'}],
        loaders: [{ test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader'}]
      },
      output: { filename: 'all.js' }
    };

    if(watch) {
      webpackOptions.devtool = 'inline-source-map';
    }

    var webpackChangeHandler = function(err, stats) {
      if(err) {
        options.errorHandler('Webpack')(err);
      }
      $.util.log(stats.toString({
        colors: $.util.colors.supportsColor,
        chunks: true,
        hash: false,
        version: true
      }));
      browserSync.reload();
      if(watch) {
        watch = false;
        callback();
      }
    };

    var sentinelLibs = [options.src + '/app/**/*.controller.js', options.src + '/app/**/*.directive.js', options.src + '/app/**/*.resource.js', options.src + '/app/index.js', options.src +"/*.js"]
    return gulp.src(sentinelLibs)
      .pipe($.webpack(webpackOptions, null, webpackChangeHandler))
      .pipe(gulp.dest(options.tmp + '/serve/app'));
  }

  gulp.task('scripts', ['config'], function () {
    return webpack(false);
  });

  gulp.task('scripts:watch', ['scripts'], function (callback) {
    return webpack(true, callback);
  });
};
