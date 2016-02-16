
var
  WebSocketServer $ require :ws
  path $ require :path
  dirReader $ require :./dir-reader

  entry $ . process.argv 3

if (not $ ? entry)
  do
    console.log ":please specify a folder"
    process.exit 1

var wss $ new WebSocketServer.Server $ object
  :port 7001

wss.on :connection $ \ (ws)

  ws.send $ JSON.stringify $ object
    :type :sync
    :data $ dirReader.getInfo entry

  ws.on :message $ \ (message)
    var
      action $ JSON.parse message
    switch action.action
      :update
        fs.writeFileSync action.file action.content
      :refresh
        ws.send $ JSON.stringify $ {}
          :type :sync
          :data $ dirReader.getInfo entry
    return

  ws.on :close $ \ ()

console.log ":started server at 7001"
