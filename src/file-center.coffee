
require('shelljs/global')
path = require 'path'
chokidar = require 'chokidar'
events = require 'events'

{pretty} = require 'cirru-writer'
{parseShort} = require 'cirru-parser'

exports.FileCenter = class extends events.EventEmitter
  constructor: ->
    @scanFiles()
    @listen()
    @watchFiles()

  scanFiles: ->
    @_files = {}
    ls('-R', process.env.PWD)
    .forEach (filepath) =>
      if (path.extname filepath) is '.cirru'
        @_files[filepath] = (cat filepath)

  fileList: ->
    Object.keys @_files

  read: (filepath) ->
    parseShort @_files[filepath]

  watchFiles: ->
    watcher = chokidar.watch process.env.PWD,
      ignored: (testFile) ->
        ['.git', 'node_modules', 'bower_components'].every (dir) ->
          (testFile.indexOf dir) >= 0
      persistent: true

    watcher.on 'change', (filepath) =>
      filepath = path.relative process.env.PWD, filepath
      if @_sleep then return
      @_files[filepath] = cat filepath
      @emit 'file-change', filepath

    watcher.on 'add', => @updateList()
    watcher.on 'addDir', => @updateList()
    watcher.on 'unlink', => @updateList()
    watcher.on 'unlinkDir', => @updateList()

  updateList: ->
    @scanFiles()
    @emit 'tree-change'

  listen: ->
    @on 'change', (filepath, code) =>
      @_files[filepath] = code
      code.to filepath
      @_sleep = yes
      setTimeout (=> @_sleep = no), 300
      @

  save: (data) ->
    name = data.name
    code = pretty data.ast

    @_files[name] = code
    @_sleep = yes
    code.to name
    @_sleep = no