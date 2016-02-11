
var
  fs $ require :fs
  path $ require :path

var isDir $ \ (name)
  var
    stat $ fs.statSync name
  stat.isDirectory

var readDir $ \ (name)
  fs.readdirSync name

var getSize $ \ (name)
  var
    stat $ fs.statSync name
  return stat.size

var getPathInfo $ \ (filepath code)
  if (isDir filepath)
    do
      = list $ readDir filepath
      = children $ list.map $ \ (child)
        = childpath $ path.join filepath child
        getPathInfo childpath code
      return $ object
        :type :dir
        :fullpath filepath
        :children children
        :name $ path.basename filepath
    do
      = (. code filepath) $ object
        :text $ fs.readFileSync filepath :utf8
        :extname $ path.extname filepath
        :size $ getSize filepath
      var info $ object
        :type :file
        :fullpath filepath
        :name $ path.basename filepath
      return info
  return

= exports.getInfo $ \ (name)
  var
    code $ object
    info $ getPathInfo name code

  object (:code code) (:tree info)
