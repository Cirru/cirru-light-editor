
= fs $ require :fs
= path $ require :path

= isDir $ \ (name)
  = stat $ fs.statSync name
  stat.isDirectory

= readDir $ \ (name)
  fs.readdirSync name

= getSize $ \ (name)
  = stat $ fs.statSync name
  return stat.size

= getPathInfo $ \ (filepath code)
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
      = info $ object
        :type :file
        :fullpath filepath
        :name $ path.basename filepath
      return info

= exports.getInfo $ \ (name)
  = code $ object
  = info $ getPathInfo name code
  object (:code code) (:tree info)
