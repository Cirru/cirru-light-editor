
server = require 'ws-json-server'

{FileCenter} = require './file-center'

files = new FileCenter

server.listen 7001, (ws) ->

  ws.on 'get-list', (data, res) ->
    res files.fileList()

  ws.on 'get-file', (filename, res) ->
    res (files.read filename)

  ws.on 'save-file', (data) ->
    files.save data

  ws.listenTo files, 'tree-change', ->
    ws.emit 'get-list', files.fileList()

  ws.listenTo files, 'file-change', (name) ->
    ws.emit 'file-change', name

site = "http://repo.cirru.org/light-editor/"
console.log "Listening 7001, visit #{site} to edit..."