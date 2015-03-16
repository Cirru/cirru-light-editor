
= store $ require :./store

= ws $ new WebSocket $ ++: :ws://localhost:7001

= ws.onmessage $ \ (msg)
  = action $ JSON.parse msg.data
  switch action.type
    :sync
      console.log :sync action.data
      store.set action.data
    :patch
      console.log :patch action.delta
      store.patch action.delta

store.dispatcher.on :change $ \ ()
  console.log (store.get)
