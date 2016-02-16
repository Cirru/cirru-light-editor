
require :cirru-editor/style/layout.css
require :../style/layout.css

var
  React $ require :react
  ReactDOM $ require :react-dom
  recorder $ require :actions-recorder

  schema $ require :./schema
  updater $ require :./updater
  App $ React.createFactory $ require :./components/app

  ws $ new WebSocket $ + :ws://localhost:7001

  render $ \ (core)
    console.log (... core (get :store) (toJS))
    ReactDOM.render
      App $ {} :core core
      document.querySelector :#app

recorder.setup $ {}
  :updater updater
  :initial schema.db

recorder.request render
recorder.subscribe render

var send $ \ (data)
  ws.send $ JSON.stringify data

= ws.onopen $ \ ()
  recorder.dispatch :device/connect

= ws.onclose $ \ ()
  recorder.dispatch :device/disconnect

= ws.onmessage $ \ (msg)
  var
    action $ JSON.parse msg.data
  console.log ":action:" action
  switch action.type
    :sync
      recorder.dispatch :collection/sync action.data
    :patch
      recorder.dispatch :collection/patch action.data
  return
