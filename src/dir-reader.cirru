
var
  fs $ require :fs
  path $ require :path
  Immutable $ require :immutable

  bind $ \ (v k) (k v)

  getPaths $ \ (filepath)
    var
      children $ Immutable.fromJS $ fs.readdirSync filepath
      filteredChildren $ children.filter $ \ (childPath)
        not $ in
          [] :node_modules :.git
          , childPath
    filteredChildren.flatMap $ \ (name)
      var
        childPath $ path.join filepath name
      cond
        ... fs (statSync childPath) (isDirectory)
        getPaths childPath
        Immutable.fromJS $ [] childPath

= exports.getInfo $ \ (currentPath)
  var
    allPaths $ getPaths currentPath (Immutable.List)
  allPaths.map $ \ (filepath)
    Immutable.fromJS $ {}
      :filepath filepath
      :extname $ path.extname filepath
      :text $ fs.readFileSync filepath :utf8
      :mtime $ bind
        . (fs.statSync filepath) :mtime
        \ (modifiedTime)
          ... (new Date modifiedTime) (valueOf)
