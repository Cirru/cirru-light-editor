
require :./style/editor-tmp.css

var
  React $ require :react
  ReactDOM $ require :react-dom
  recorder $ require :actions-recorder
  urlParse $ require :url-parse

  schema $ require :./schema
  updater $ require :./updater
  App $ React.createFactory $ require :./components/app

  pageUrl $ urlParse (location.toString) true
  domain $ cond (? pageUrl.query)
    or pageUrl.query.domain :localhost
    , :localhost
  port $ cond (? pageUrl.query)
    or pageUrl.query.port :7001
    , :7001
  ws $ new WebSocket $ + :ws:// domain :: port

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
  mixpanel.track ":light-editor connected"
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
