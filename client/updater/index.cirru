
var
  device $ require :./device
  collection $ require :./collection

  id $ \ (x) x

= module.exports $ \ (db type data)
  var
    handler $ case type
      :device/connect device.connect
      :device/disconnect device.disconnect

      :collection/sync collection.sync
      :collection/patch collection.patch

      else id

  handler db data
