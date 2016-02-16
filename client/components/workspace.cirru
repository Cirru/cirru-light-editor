
var
  React $ require :react

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-workspace

  :render $ \ ()
    div ({} :style @styleRoot) ":Workspace"

  :styleRoot $ {}
    :display :flex
    :flexDirection :row
    :alignItems :center
    :justifyContent :center
