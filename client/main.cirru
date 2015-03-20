
= React $ require :react
require :cirru-editor/style/layout.css

= store $ require :./store
= actions $ require :./actions
= App $ React.createFactory $ require :./components/app

= ws $ new WebSocket $ ++: :ws://localhost:7001

= actions.send $ \ (data)
  ws.send $ JSON.stringify data

= ws.onmessage $ \ (msg)
  = action $ JSON.parse msg.data
  switch action.type
    :sync
      console.log :sync action.data
      store.set action.data
    :patch
      console.log :patch action.delta
      store.patch action.delta

React.render (App) document.body
