require './src/globals'
settings = require './src/settings'
gulp = require 'gulp'
gutil = require 'gulp-util'

gulp.task 'clean', ->
  del = require 'del'
  del.sync 'lib'

buildBrowserify = do ->
  browserify = require 'browserify'
  reactify = require 'coffee-reactify'

  cache = {}
  packageCache = {}

  (options={}) ->
    browserify Object.assign options,
      extensions: ['.coffee', '.cjsx']
      insertGlobals: true # faster
      cache: cache
      packageCache: packageCache
      fullPaths: true
    .transform reactify

gulp.task 'compile:tests', ->
  transform = require 'vinyl-transform'
  rename = require 'gulp-rename'

  gulp.src ['./src/**/*.test.coffee', '!./src/integration.test.coffee']
  .pipe transform (filename) ->
    buildBrowserify
      entries: [
        './src/test_environment/base.coffee'
        filename
      ],
      debug: true
    .bundle()
  .pipe rename extname: '.js'
  .pipe gulp.dest 'lib/tests'

gulp.task 'test:unit', ['compile:tests'], (done) ->
  karma = require('karma').server
  karma.start
    configFile: __dirname + '/karma.conf.coffee'
    singleRun: true
  , done

gulp.task 'test:integration', ['compile:app', 'serve:dev', 'serve:selenium'], (done) ->
  {spawn} = require 'child_process'

  mocha = spawn 'mocha', [
    '--compilers', 'coffee:coffee-script/register'
    '--reporter', 'spec'
    '--timeout', 10000
    'src/integration.test.coffee'
  ],
    env: Object.assign({}, process.env, PORT: settings.port)
    stdio: 'inherit'
  .on 'exit', (code) -> done(code or null)

  return null # don't return a stream

gulp.task 'test', ['test:unit', 'test:integration']

gulp.task 'compile:app', ->
  source = require 'vinyl-source-stream'
  rename = require 'gulp-rename'
  watchify = require 'watchify'

  bundler = buildBrowserify
    entries: './src/app.cjsx'
    debug: true

  if settings.watch
    bundler = watchify bundler
    .on 'update', ->
      gutil.log 'Watchify', gutil.colors.cyan arguments[0]
      bundle()

  bundle = ->
    b = bundler.bundle()
    if settings.watch
      b.on 'error', ->
        gutil.log 'Browserify Error', gutil.colors.red arguments...
    b
    .pipe source 'app.js'
    .pipe gulp.dest 'lib'

  bundle()

gulp.task 'serve:selenium', ->
  selenium = require 'selenium-standalone'
  tcpPort = require 'tcp-port-used'

  selenium
    stdio: 'ignore'
    ['-port', settings.seleniumServer.port]
  .unref()

  tcpPort.waitUntilUsed(settings.seleniumServer.port, 500, 20000)

gulp.task 'serve:dev', (done) ->
  connect = require 'connect'
  serveStatic = require 'serve-static'
  http = require 'http'
  port = settings.port

  app = connect()
  .use serveStatic('.')

  http.createServer app
  .on 'error', (err) ->
    if err.code is 'EADDRINUSE'
      fallbackPort = port + Math.floor(Math.random() * 1000)
      gutil.log "#{port} is busy, trying #{fallbackPort}"
      setImmediate -> server.listen fallbackPort
    else
      throw err
  .on 'listening', ->
    settings.port = @address().port
    @unref()
    done()
  .listen port

gulp.task 'keepalive', ->
  setInterval (->), 10000

gulp.task 'dev', ['compile:app', 'serve:dev', 'keepalive']

gulp.task 'open', ['dev'], ->
  open = require 'open'
  open settings.devServerUrl()

