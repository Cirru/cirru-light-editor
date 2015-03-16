
= events $ require :events
= _ $ require :lodash
= jsondiffpatch $ require :jsondiffpatch

= diffpatch $ jsondiffpatch.create $ object
  :objectHash $ \ (obj) obj.fullpath
  :textDiff $ object
    :minLength 20

= dispatcher $ new events.EventEmitter

= store $ object

= exports.dispatcher dispatcher

= exports.get $ \ ()
  return store

= exports.set $ \ (data)
  = delta $ diffpatch.diff store data
  = store $ _.cloneDeep data
  dispatcher.emit :change $ object
    :type :patch
    :delta delta
