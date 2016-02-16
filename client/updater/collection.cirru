
= exports.sync $ \ (db data)
  db.set :collection data

= exports.patch $ \ (db data) db
