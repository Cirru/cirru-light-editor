
= events $ require :events
= _ $ require :lodash
= jsondiffpatch $ require :jsondiffpatch

= diffpatch $ jsondiffpatch.create $ object
  :objectHash $ \ (obj) obj.fullpath

= dispatcher $ new events.EventEmitter

= store $ object

= exports.dispatcher dispatcher

= exports.get $ \ ()
  store

= exports.set $ \ (data)
  = diff $ diffpatch.diff store data
  = store $ _.cloneDeep data
  dispatcher.emit :change diff
