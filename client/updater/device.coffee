
exports.connect = (db, data) ->
  db.setIn ['device', 'isConnected'], true

exports.disconnect = (db, data) ->
  db
  .setIn(['device', 'isConnected'], false)
  .setIn ['device', 'isErrored'], true
