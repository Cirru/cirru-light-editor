
require :cirru-editor/style/layout.css

var
  React $ require :react
  ReactDOM $ require :react-dom
  recorder $ require :actions-recorder

  schema $ require :./schema
  updater $ require :./updater
  App $ React.createFactory $ require :./components/app

  ws $ new WebSocket $ + :ws://repo:7001

  send $ \ (type data)
    ws.send $ JSON.stringify $ [] type data

  render $ \ (core)
    console.log (... core (get :store) (toJS))
    ReactDOM.render
      App $ {} :core core :send send
      document.querySelector :#app

recorder.setup $ {}
  :updater updater
  :initial schema.db

recorder.request render
recorder.subscribe render

= ws.onopen $ \ ()
  recorder.dispatch :device/connect

= ws.onclose $ \ ()
  recorder.dispatch :device/disconnect
  setTimeout
    \ ()
      location.reload
    , 4000

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

if module.hot $ do
  module.hot.accept :./components/app $ \ ()
    = App $ React.createFactory $ require :./components/app
    recorder.request render
