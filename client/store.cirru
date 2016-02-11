
var
  jsondiffpatch $ require :jsondiffpatch
  events $ require :events

  diffpatch $ jsondiffpatch.create $ object
    :objectHash $ \ (obj) obj.fullpath
    :textDiff $ object
      :minLength 20

  dispatcher $ new events.EventEmitter

  store $ object

= exports.get $ \ () store

= exports.getCode $ \ () store.code

= exports.getTree $ \ () store.tree

= exports.dispatcher dispatcher

= exports.set $ \ (data)
  = store data
  dispatcher.emit :change

= exports.patch $ \ (delta)
  diffpatch.patch store delta
  dispatcher.emit :change
