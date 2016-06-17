
var
  hsl $ require :hsl
  React $ require :react

  ({}~ a div span) React.DOM
  guideUrl :https://github.com/Cirru/cirru-light-editor/wiki/Start-using-Cirru-Editor

= module.exports $ React.createClass $ {}
  :displayName :app-connecting

  :render $ \ ()
    div ({} :style @styleRoot)
      div ({} :style @styleStatus)
        cond (@props.device.get :isErrored)
          div ({})
            span ({}) ":No Connection"
          span ({}) ":Connecting ..."
      div ({} :style @styleMain)
        span ({}) ":Cirru Editor is a tree editor. "
        a ({} :href guideUrl) ":Read guides on GitHub."
      div ({} :style @styleHint) ":`Command + Shift + j` to see logs."
      div ({} :style @styleHint) ":`Command + r` to retry."

  :styleRoot $ {}
    :position :absolute
    :top 0
    :left 0
    :fontFamily ":Source Code Pro, Menlo, Consolas, monospace"
    :fontSize 14
    :padding 40
    :lineHeight 2

  :styleStatus $ {}
    :fontSize 20
    :backgroundColor $ hsl 0 90 70
    :color :white
    :padding ":0 16px"
    :borderRadius 0
    :display :inline-block

  :styleHint $ {}
    :color $ hsl 0 0 60

  :styleMain $ {}
    :marginTop 40
