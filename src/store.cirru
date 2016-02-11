
var
  events $ require :events
  _ $ require :lodash
  jsondiffpatch $ require :jsondiffpatch

var diffpatch $ jsondiffpatch.create $ object
  :objectHash $ \ (obj) obj.fullpath
  :textDiff $ object
    :minLength 20

var dispatcher $ new events.EventEmitter

var store $ object

= exports.dispatcher dispatcher

= exports.get $ \ ()
  return store

= exports.set $ \ (data)
  var
    delta $ diffpatch.diff store data
    store $ _.cloneDeep data
  dispatcher.emit :change $ object
    :type :patch
    :delta delta
