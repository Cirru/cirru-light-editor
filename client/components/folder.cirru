
var
  iconFolded :►
  iconExpanded :▼

  React $ require :react

  div $ React.createFactory :div
  span $ React.createFactory :span
  File $ React.createFactory $ require :./file

  T React.PropTypes

var Editor $ React.createClass $ object
  :displayName :folder

  :propTypes $ object
    :data T.object.isRequired
    :onSelect T.func.isRequired
    :open T.string.isRequired

  :getInitialState $ \ ()
    object
      :isExpanded true

  :onToggle $ \ (event)
    event.stopPropagation
    @setState $ object
      :isExpanded $ not @state.isExpanded

  :onFileClick $ \ (data)
    @props.onSelect data

  :renderChildren $ \ ()
    @props.data.children.map $ \\ (child index)
      cond (is child.type :file)
        File $ object (:data child) (:onClick @onFileClick)
          :key index
          :open @props.open
        FolderFactory $ object (:data child) (:onSelect @onFileClick)
          :key index
          :open @props.open

  :render $ \ ()
    div
      object (:className :folder)
      div
        object (:className :line) (:onClick @onToggle)
        span
          object (:className :name)
          , @props.data.name
        span
          object (:className :icon)
          cond @state.isExpanded iconExpanded iconFolded
      cond @state.isExpanded
        div
          object (:className :children)
          @renderChildren
        , null

var FolderFactory $ React.createFactory Editor

= module.exports Editor
