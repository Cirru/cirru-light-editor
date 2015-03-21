
= fs $ require :fs
= writer $ require :cirru-writer

= exports.write $ \ (filename ast)
  = code $ writer.render ast
  fs.writeFileSync filename code
