
exports.trackAction = (action) ->
  ga 'send', 'event', 'light-editor', action
