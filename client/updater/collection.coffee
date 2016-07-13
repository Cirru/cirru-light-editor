
immutablepatch = require('immutablepatch')

exports.sync = (db, data) ->
  db.set 'collection', data

exports.patch = (db, data) ->
  db.update 'collection', (collection) ->
    immutablepatch collection, data
