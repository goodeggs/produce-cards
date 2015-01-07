require './src/globals'
gutil = require 'gulp-util'
settings = require './src/settings'
connect = require 'connect'
serveStatic = require 'serve-static'
http = require 'http'
request = require 'request'
port = settings.port

app = connect()
.use serveStatic('.')
.use (req, res) ->
  request "https://api.goodeggs.com/market-sections/nyc/produce"
  .pipe res

module.exports = http.createServer app
.on 'error', (err) ->
  if err.code is 'EADDRINUSE'
    fallbackPort = port + Math.floor(Math.random() * 1000)
    gutil.log "#{port} is busy, trying #{fallbackPort}"
    setImmediate => @listen fallbackPort
  else
    throw err
.on 'listening', ->
  settings.port = @address().port
.listen port
