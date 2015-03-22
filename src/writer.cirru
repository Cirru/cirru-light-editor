
= fs $ require :fs

= exports.write $ \ (filename content)
  fs.writeFileSync filename content
