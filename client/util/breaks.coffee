getHeadSpace = (text, head) ->
  if text[0] == ' ' then getHeadSpace(text.substr(1), head + ' ') else head

exports.manualBreaks = (input) ->
  start = input.selectionStart
  code = input.value
  before = code.substr(0, start)
  after = code.substr(start)
  lines = before.split('\n')
  lastLine = lines[lines.length - 1]
  headSpace = getHeadSpace(lastLine, '')
  event = document.createEvent('Event')
  input.value = before + '\n' + headSpace + after
  input.selectionStart = input.selectionEnd = start + headSpace.length + 1
  event.initEvent 'change', true, true
  input.dispatchEvent event
