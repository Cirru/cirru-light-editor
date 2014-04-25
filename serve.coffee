
server = require 'ws-json-server'

{FileCenter} = require './src/file-center'

server.listen 7001, (ws) ->
  
  ws.on 'repeat', (n) ->
    setTimeout ->
      ws.emit 'repeat', (n + 1)
    , 1000
    console.log 'repeat', n

files = new FileCenter
console.log files.fileList()