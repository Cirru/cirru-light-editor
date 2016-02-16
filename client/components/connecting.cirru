
var
  hsl $ require :hsl
  React $ require :react

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-connecting

  :render $ \ ()
    div ({} :style @styleRoot) ":Connecting to localhost:7001 ..."

  :styleRoot $ {}
    :position :absolute
    :top 0
    :left 0
    :height :100%
    :width :100%
    :display :flex
    :flexDirection :row
    :alignItems :center
    :justifyContent :center
    :fontFamily ":Verdana"
    :fontSize 16
    :backgroundColor $ hsl 230 80 60
    :color :white
