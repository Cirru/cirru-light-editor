
= fs $ require :fs
= path $ require :path

= root process.env.PWD

= isDir $ \ (name)
  = stat $ fs.statSync name
  stat.isDirectory

= readDir $ \ (name)
  fs.readdirSync name

= getSize $ \ (name)
  = stat $ fs.statSync name
  console.log stat.size
  return stat.size

= getPathInfo $ \ (filepath)
  if (isDir filepath)
    do
      = list $ readDir filepath
      = children $ list.map $ \ (child)
        = childpath $ path.join filepath child
        getPathInfo childpath
      return $ object
        :type :dir
        :fullpath filepath
        :children children
    do
      = info $ object
        :type :file
        :fullpath filepath
        :extname $ path.extname filepath
        :content $ fs.readFileSync filepath :utf8
        :size $ getSize filepath
      return info

= exports.getInfo $ \ (name)
  = fullpath $ path.join root name
  getPathInfo fullpath
