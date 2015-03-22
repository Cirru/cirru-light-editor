
= gulp $ require :gulp
= env $ or process.env.WEB_ENV :dev

switch env
  :min
    = config $ require :./webpack.min
  else
    = config $ require :./webpack.config

gulp.task :html $ \ ()
  = html $ require :gulp-cirru-html
  = assets $ require :./assets

  = data $ object
    :main $ ++: config.output.publicPath assets.main

  ... gulp
    :src :./index.cirru
    :pipe $ html $ object (:data data)
    :pipe $ gulp.dest :./

gulp.task :script $ \ ()
  = script $ require :gulp-cirru-script
  = rename $ require :gulp-rename

  ... gulp
    :src :src/*.cirru
    :pipe $ script $ object (:dest :../lib)
    :pipe $ rename $ object (:extname :.js)
    :pipe $ gulp.dest :lib

gulp.task :rsync $ \ (cb)
  = wrapper $ require :rsyncwrapper
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
