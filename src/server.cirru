
var
  WebSocketServer $ require :ws
  gaze $ require :gaze
  path $ require :path
  dirReader $ require :./dir-reader

  store $ require :./store
  writer $ require :./writer

  entry $ . process.argv 2

if (not $ ? entry)
  do
    console.log ":please specify a folder"
    process.exit 1

var watcher $ new gaze.Gaze $ path.join entry :** :*

var wss $ new WebSocketServer.Server $ object
  :port 7001

wss.on :connection $ \ (ws)

  ws.send $ JSON.stringify $ object
    :type :sync
    :data (store.get)

  ws.on :message $ \ (message)
    = action $ JSON.parse message
    switch action.action
      :update
        writer.write action.file action.content
    return

  ws.on :close $ \ ()

store.set $ dirReader.getInfo entry

watcher.on :all $ \ (event filepath)
  console.log filepath
  store.set $ dirReader.getInfo entry

store.dispatcher.on :change $ \ (delta)
  wss.clients.forEach $ \ (ws)
    ws.send $ JSON.stringify delta

console.log ":started server at 7001"
