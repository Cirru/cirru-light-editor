
= jsondiffpatch $ require :jsondiffpatch
= events $ require :events

= diffpatch $ jsondiffpatch.create $ object
  :objectHash $ \ (obj) obj.fullpath
  :textDiff $ object
    :minLength 20

= dispatcher $ new events.EventEmitter

= store $ object

= exports.get $ \ () store

= exports.dispatcher dispatcher

= exports.set $ \ (data)
  = store data

= exports.patch $ \ (delta)
  diffpatch.patch store delta
  dispatcher.emit :change
