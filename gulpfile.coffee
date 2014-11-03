gulp = require 'gulp'

gulp.task 'clean', ->
  del = require 'del'
  del.sync 'lib'

browserifyCache =
  cache: {}
  packageCache: {}

gulp.task 'compile-tests', ->
  glob = require 'glob'
  browserify = require 'browserify'
  reactify = require 'coffee-reactify'
  transform = require 'vinyl-transform'
  rename = require 'gulp-rename'

  gulp.src ['./src/**/*.test.coffee']
  .pipe transform (filename) ->
    browserify
      entries: [
        './src/test_environment.coffee'
        filename
      ]
      extensions: ['.coffee']
      debug: true
      insertGlobals: true # faster
      cache: browserifyCache.cache
      packageCache: browserifyCache.packageCache
      fullPaths: true
    .transform reactify
    .bundle()
  .pipe rename extname: '.js'
  .pipe gulp.dest 'lib/tests'

gulp.task 'test', ['compile-tests'], (done) ->
  karma = require('karma').server
  karma.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  , done
