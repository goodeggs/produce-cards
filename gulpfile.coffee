gulp = require 'gulp'
gutil = require 'gulp-util'
_ = require 'underscore'

settings =
  port: 3000
  devServerUrl: -> "http://localhost:#{@port}"

gulp.task 'clean', ->
  del = require 'del'
  del.sync 'lib'

buildBrowserify = do ->
  browserify = require 'browserify'
  reactify = require 'coffee-reactify'

  cache = {}
  packageCache = {}

  (options={}) ->
    browserify _.extend options,
      extensions: ['.coffee', '.cjsx']
      insertGlobals: true # faster
      cache: cache
      packageCache: packageCache
      fullPaths: true
    .transform reactify

gulp.task 'compile:tests', ->
  transform = require 'vinyl-transform'
  rename = require 'gulp-rename'

  gulp.src ['./src/**/*.test.coffee']
  .pipe transform (filename) ->
    buildBrowserify
      entries: [
        './src/test_environment.coffee'
        filename
      ],
      debug: true
    .bundle()
  .pipe rename extname: '.js'
  .pipe gulp.dest 'lib/tests'

gulp.task 'test', ['compile:tests'], (done) ->
  karma = require('karma').server
  karma.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  , done

gulp.task 'compile:dev', ->
  source = require 'vinyl-source-stream'
  rename = require 'gulp-rename'
  watchify = require 'watchify'

  bundler = watchify buildBrowserify
    entries: './src/app.cjsx'
    debug: true

  .on 'update', ->
    gutil.log 'Watchify', gutil.colors.cyan arguments[0]
    bundle()

  bundle = ->
    bundler.bundle()
    .on 'error', ->
      gutil.log 'Browserify Error', gutil.colors.red arguments...
    .pipe source 'app.js'
    .pipe gulp.dest 'lib'

  bundle()

gulp.task 'serve:dev', (done) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'
  http = require 'http'

  app = connect()
  .use serveStatic('.')

  http.createServer app
  .on 'listening', ->
    done()
  .listen settings.port

gulp.task 'dev', ['compile:dev', 'serve:dev']

gulp.task 'open', ['dev'], ->
  open = require 'open'
  open settings.devServerUrl()

