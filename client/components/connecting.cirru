
var
  React $ require :react

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-connecting

  :render $ \ ()
    div ({} :style @styleRoot) ":Connecting to localhost:7001"

  :styleRoot $ {}
    :display :flex
    :flexDirection :row
    :alignItems :center
    :justifyContent :center
