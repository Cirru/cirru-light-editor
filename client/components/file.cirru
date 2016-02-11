
var
  React $ require :react
  classnames $ require :classnames

  div $ React.createFactory :div
  T React.PropTypes

= module.exports $ React.createClass $ object
  :displayName :file

  :propTypes $ object
    :data T.object.isRequired
    :onClick T.func.isRequired
    :open T.string.isRequired

  :onClick $ \ ()
    @props.onClick @props.data

  :render $ \ ()
    var className $ classnames $ object
      :file true
      :line true
      :is-open $ is @props.open @props.data.fullpath

    div
      object
        :className className
        :onClick @onClick
      , @props.data.name
