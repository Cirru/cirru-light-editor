
= WebSocketServer $ require :ws
= gaze $ require :gaze
= path $ require :path
= dirReader $ require :./dir-reader

= store $ require :./store

= entry :demo

= watcher $ new gaze.Gaze $ path.join entry :** :*.cirru

= wss $ new WebSocketServer.Server $ object
  :port 7001

wss.on :connection $ \ (ws)

  ws.send $ JSON.stringify $ object
    :type :sync
    :data (store.get)

  ws.on :message $ \ (message)
    = action $ JSON.parse message

  ws.on :close $ \ ()

store.set $ dirReader.getInfo entry

watcher.on :all $ \ (event filepath)
  console.log filepath
  store.set $ dirReader.getInfo entry

store.dispatcher.on :change $ \ (delta)
  wss.clients.forEach $ \ (ws)
    ws.send $ JSON.stringify delta

console.log ":started server at 7001"
