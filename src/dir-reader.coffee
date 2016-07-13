
fs = require('fs')
path = require('path')
Immutable = require('immutable')

bind = (v, k) ->
  k v

getPaths = (filepath) ->
  children = Immutable.fromJS(fs.readdirSync(filepath))
  filteredChildren = children.filter((childPath) ->
    !([
      'node_modules'
      '.git'
      'resources'
    ].indexOf(childPath) >= 0)
  )
  filteredChildren.flatMap (name) ->
    childPath = path.join(filepath, name)
    if fs.statSync(childPath).isDirectory() then getPaths(childPath) else Immutable.fromJS([ childPath ])

exports.getInfo = (currentPaths) ->
  currentPaths.flatMap (currentPath) ->
    allPaths = getPaths(currentPath, Immutable.List())
    allPaths.map (filepath) ->
      Immutable.fromJS
        filepath: filepath
        baseDirectory: currentPath
        extname: path.extname(filepath)
        text: fs.readFileSync(filepath, 'utf8')
        mtime: bind(fs.statSync(filepath).mtime, (modifiedTime) ->
          new Date(modifiedTime).valueOf()
        )
