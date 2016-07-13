
fs = require('fs')
WebSocketServer = require('ws')
path = require('path')
Immutable = require('immutable')
immutablediff = require('immutablediff')
dirReader = require('./dir-reader')
entries = process.argv.slice(2).map((entry) ->
  if entry[0] == '/' then entry else path.join(process.env.PWD, entry)
)
port = if process.env.PORT != null then parseInt(process.env.PORT) else 7001
if entries.length == 0
  console.log 'please specify a folder'
  process.exit 1
wss = new (WebSocketServer.Server)(port: port)

refreshCollection = ->
  dirReader.getInfo Immutable.fromJS(entries)

collectionAtom = refreshCollection()
wss.on 'connection', (ws) ->
  ws.send JSON.stringify(
    type: 'sync'
    data: collectionAtom)
  ws.on 'message', (message) ->
    action = JSON.parse(message)
    actionData = action[1]
    switch action[0]
      when 'update-file'
        fs.writeFileSync actionData.file, actionData.text
        console.log 'update file:', actionData.file
        newCollectionAtom = collectionAtom.map((file) ->
          if file.get('filepath') == actionData.file then file.set('text', actionData.text) else file
        )
        delta = immutablediff(collectionAtom, newCollectionAtom)
        collectionAtom = newCollectionAtom
        ws.send JSON.stringify(
          type: 'patch'
          data: delta)
      when 'refresh'
        collectionAtom = refreshCollection()
        ws.send JSON.stringify(
          type: 'sync'
          data: collectionAtom)
    return
  ws.on 'close', ->
console.log 'started server at ' + port
