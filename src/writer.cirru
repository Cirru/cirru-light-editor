
= fs $ require :fs
= writer $ require :cirru-writer

= exports.write $ \ (filename ast)
  = code $ writer.pretty ast
  fs.writeFileSync filename code
