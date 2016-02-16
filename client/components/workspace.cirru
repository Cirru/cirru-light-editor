
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable

  Finder $ React.createFactory $ require :./finder

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-workspace

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired

  :renderEditor $ \ ()
    div ({} :style @styleEditor)

  :renderSidebar $ \ ()
    div ({} :style @styleSidebar)
      Finder $ {} :collection @props.collection

  :render $ \ ()
    div ({} :style @styleRoot)
      @renderEditor
      @renderSidebar

  :styleRoot $ {}
    :position :absolute
    :top 0
    :left 0
    :width :100%
    :height :100%
    :display :flex
    :flexDirection :row
    :alignItems :stretch
    :justifyContent :center
    :fontFamily ":Verdana"

  :styleSidebar $ {}
    :backgroundColor $ hsl 0 80 100
    :width 400
    :position :relative

  :styleEditor $ {}
    :backgroundColor $ hsl 200 40 40
    :flex 1
