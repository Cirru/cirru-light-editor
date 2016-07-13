device = require('./device')
collection = require('./collection')

id = (x) ->
  x

module.exports = (db, type, data) ->
  handler =
    switch type
      when 'device/connect'
        device.connect
      when 'device/disconnect'
        device.disconnect
      when 'collection/sync'
        collection.sync
      when 'collection/patch'
        collection.patch
      else
        id

  handler db, data
