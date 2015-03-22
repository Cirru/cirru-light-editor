

= getHeadSpace $ \ (text head)
  if (is (. text 0) ": ")
    do $ return $ getHeadSpace (text.substr 1) (++: head ": ")
    do $ return head

= module.exports $ object
  :manualBreaks $ \ (input)
    = start input.selectionStart
    = code input.value
    = before $ code.substr 0 start
    = after $ code.substr start
    = lines $ before.split ":\n"
    = lastLine $ . lines $ - lines.length 1
    = headSpace $ getHeadSpace lastLine :

    = input.value $ ++: before ":\n" headSpace after
    = input.selectionStart $ = input.selectionEnd $ + start headSpace.length 1

    = event $ document.createEvent :Event
    event.initEvent :change true true
    input.dispatchEvent event

    return undefined
