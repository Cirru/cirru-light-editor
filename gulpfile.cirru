
var
  fs $ require :fs
  gulp $ require :gulp
  gutil $ require :gutil
  env :dev
  sequence $ require :run-sequence
  settings $ require :./tasks/settings

gulp.task :html $ \ (cb)
  var
    html $ require :./tasks/template
  fs.writeFile :build/index.html (html env) cb

gulp.task :script $ \ ()
  var
    script $ require :gulp-cirru-script

  ... gulp
    src :src/*.cirru
    pipe $ script $ object (:dest :../lib)
    pipe $ gulp.dest :lib

gulp.task :rsync $ \ (cb)
  var
    wrapper $ require :rsyncwrapper
  wrapper.rsync
    object
      :ssh true
      :src $ array :index.html :dist :style
      :recursive true
      :args $ array :--verbose
      :dest :tiye:~/repo/cirru/light-editor/
      :deleteAll true
    \ (error stdout stderr cmd)
      if (? error)
        do $ throw error
      if (? stderr)
        do $ console.error stderr
        do $ console.log cmd
      cb

gulp.task :webpack-dev $ \ (cb)
  var
    webpack $ require :webpack
    webpackDev $ require :./tasks/webpack-dev
    WebpackDevServer $ require :webpack-dev-server
    config $ settings.get :dev
  var webpackServer $ {}
    :publicPath :/
    :hot true
    :stats $ {}
      :colors true
  var info $ {}
    :__dirname __dirname
    :env env

  var compiler $ webpack (webpackDev info)
  var server $ new WebpackDevServer compiler webpackServer

  server.listen config.port :0.0.0.0 $ \ (err)
    if (? err) $ do
      throw $  new gutil.PluginError :webpack-dev-server err
    gutil.log ":[webpack-dev-server] is running..."
    cb

gulp.task :webpack-build $ \ (cb)
  var
    webpack $ require :webpack
    webpackBuild $ require :./tasks/webpack-build
    config $ settings.get env
  var info $ {}
    :__dirname __dirname
    :isMinified config.isMinified
    :useCDN config.useCDN
    :cdn config.cdn
    :env config.env
  webpack (webpackBuild info) $ \ (err stats)
    if err $ do
      throw $ new gutil.PluginError :webpack  err
    gutil.log :[webpack] (stats.toString)
    var jsonData $ stats.toJson
    var fileContent $ JSON.stringify jsonData.assetsByChunkName
    fs.writeFileSync :tasks/assets.json fileContent
    cb

gulp.task :webpack-server $ \ (cb)
  var
    webpack $ require :webpack
    serverConfig $ require :./tasks/webpack-server

  ... (webpack serverConfig) $ run $ \ (err stats)
    if err
      do $ console.log err
      do $ console.log (stats.toString)
    cb

  ... (webpack serverConfig) $ watch 100 $ \ (err stats)
    if err
      do $ console.log err
      do $ console.log (stats.toString)
    , null

-- ":aliases"

gulp.task :dev $ \ (cb)
  sequence :html :webpack-dev cb

gulp.task :build $ \ (cb)
  = env :build
  sequence :del :webpack-build :html cb
