
var
  fs $ require :fs
  WebSocketServer $ require :ws
  path $ require :path
  immutablediff $ require :immutablediff

  dirReader $ require :./dir-reader

  entry $ . process.argv 2

if (not $ ? entry)
  do
    console.log ":please specify a folder"
    process.exit 1

var
  wss $ new WebSocketServer.Server $ {} :port 7001
  refreshCollection $ \ ()
    dirReader.getInfo $ cond
      is (. entry 0) :/
      , entry
      path.join process.env.PWD entry
  collectionAtom $ refreshCollection

wss.on :connection $ \ (ws)

  ws.send $ JSON.stringify $ {}
    :type :sync
    :data collectionAtom

  ws.on :message $ \ (message)
    var
      action $ JSON.parse message
      actionData $ . action 1
    switch (. action 0)
      :update-file
        fs.writeFileSync actionData.file actionData.text
        console.log ":update file:" actionData.file
        var
          newCollectionAtom $ collectionAtom.map $ \ (file)
            cond
              is (file.get :filepath) actionData.file
              file.set :text actionData.text
              , file
          delta $ immutablediff collectionAtom newCollectionAtom
        = collectionAtom newCollectionAtom
        ws.send $ JSON.stringify $ {}
          :type :patch
          :data delta
      :refresh
        = collectionAtom $ refreshCollection
        ws.send $ JSON.stringify $ {}
          :type :sync
          :data collectionAtom
    return

  ws.on :close $ \ ()

console.log ":started server at 7001"
