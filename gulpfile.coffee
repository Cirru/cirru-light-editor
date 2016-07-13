fs = require('fs')
gulp = require('gulp')
gutil = require('gutil')
env = 'dev'
sequence = require('run-sequence')
settings = require('./tasks/settings')

gulp.task 'html', (cb) ->
  html = require('./tasks/template')
  fs.writeFile 'build/index.html', html(env), cb

gulp.task 'script', ->
  coffee = require('gulp-coffee')
  gulp.src('src/*.coffee').pipe(coffee(dest: '../lib')).pipe gulp.dest('lib')

gulp.task 'del', (cb) ->
  del = require('del')
  del [ 'build/**/*' ], cb

gulp.task 'rsync', (cb) ->
  wrapper = require('rsyncwrapper')
  wrapper.rsync {
    ssh: true
    src: [ 'build/' ]
    recursive: true
    args: [ '--verbose' ]
    dest: 'tiye:~/repo/Cirru/light-editor/'
    deleteAll: true
  }, (error, stdout, stderr, cmd) ->
    console.log error, stdout, stderr, cmd
    if error != null
      throw error
    if stderr != null
      console.error stderr
    else
      console.log cmd
    cb()
gulp.task 'webpack-dev', (cb) ->
  webpack = require('webpack')
  webpackDev = require('./tasks/webpack-dev')
  WebpackDevServer = require('webpack-dev-server')
  config = settings.get('dev')
  webpackServer =
    publicPath: '/'
    hot: true
    stats: colors: true
  info =
    __dirname: __dirname
    env: env
  compiler = webpack(webpackDev(info))
  server = new WebpackDevServer(compiler, webpackServer)
  server.listen config.port, '0.0.0.0', (err) ->
    if err != undefined
      console.log gutil, err
    gutil.log '[webpack-dev-server] is running...'
    cb()

gulp.task 'webpack-build', (cb) ->
  webpack = require('webpack')
  webpackBuild = require('./tasks/webpack-build')
  config = settings.get(env)
  info =
    __dirname: __dirname
    isMinified: config.isMinified
    useCDN: config.useCDN
    cdn: config.cdn
    env: config.env
  webpack webpackBuild(info), (err, stats) ->
    if err
      throw new (gutil.PluginError)('webpack', err)
    gutil.log '[webpack]', stats.toString()
    jsonData = stats.toJson()
    fileContent = JSON.stringify(jsonData.assetsByChunkName)
    fs.writeFileSync 'tasks/assets.json', fileContent
    cb()

gulp.task 'webpack-server', (cb) ->
  webpack = require('webpack')
  serverConfig = require('./tasks/webpack-server')
  webpack(serverConfig).run (err, stats) ->
    if err
      console.log err
    else
      console.log stats.toString()
    cb()
  webpack(serverConfig).watch 100, (err, stats) ->
    if err
      console.log err
    else
      console.log stats.toString()
    null


gulp.task 'dev', (cb) ->
  sequence 'html', 'webpack-dev', cb

gulp.task 'build', (cb) ->
  env = 'build'
  sequence 'del', 'webpack-build', 'html', cb
