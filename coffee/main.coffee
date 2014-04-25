
client = require 'ws-json-browser'

client.connect 'localhost', 7001, (ws) ->
  ws.emit 'repeat', 1

  ws.on 'repeat', (n) ->
    ws.emit 'repeat', (n + 1)
    console.log 'repeat', n