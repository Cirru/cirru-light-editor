
var
  React $ require :react
  Immutable $ require :immutable

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-finder

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired

  :render $ \ ()
    div ({}) ":app-finder"
