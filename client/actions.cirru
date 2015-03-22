
= exports.send $ \ ()
  console.warn ":need to implement send"

= exports.update $ \ (file content)
  @send $ object
    :action :update
    :file file
    :content content
