
require('shelljs/global')
path = require 'path'
{generate} = require 'cirru-writer'
chokidar = require 'chokidar'
events = require 'events'
{parseShort} = require 'cirru-parser'

exports.FileCenter = class extends events.EventEmitter
  constructor: ->
    @_files = {}
    @scanFiles()
    @listen()
    @watchFiles()

  scanFiles: ->
    ls('-R', process.env.PWD)
    .forEach (filepath) =>
      if (path.extname filepath) is '.cirru'
        @_files[filepath] = (cat filepath)

  fileList: ->
    Object.keys @_files

  requestFile: (filepath) ->
    @_files[filepath]

  watchFiles: ->
    watcher = chokidar.watch process.env.PWD,
      ignored: (testFile) ->
        ['.git', 'node_modules', 'bower_components'].every (dir) ->
          (testFile.indexOf dir) >= 0
      persistent: true

    watcher.on 'change', (filepath) =>
      console.log filepath
      if @_sleep then return
      @_files[filepath] = cat filepath
      @emit 'change', filepath, @_files[filepath]

  listen: ->
    @on 'change', (filepath, code) =>
      @_files[filepath] = code
      code.to filepath
      @_sleep = yes
      setTimeout (=> @_sleep = no), 300
      @