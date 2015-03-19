
= iconFolded :►
= iconExpanded :▼

= React $ require :react

= div $ React.createFactory :div
= span $ React.createFactory :span
= File $ React.createFactory $ require :./file

= T React.PropTypes

= Editor $ React.createClass $ object
  :displayName :folder

  :propTypes $ object
    :data T.object.isRequired
    :onSelect T.func.isRequired
    :open T.string.isRequired

  :getInitialState $ \ ()
    object
      :isExpanded false

  :onToggle $ \ (event)
    event.stopPropagation
    @setState $ object
      :isExpanded $ not @state.isExpanded

  :onFileClick $ \ (data)
    @props.onSelect data

  :renderChildren $ \ ()
    @props.data.children.map $ \= (child index)
      if (is child.type :file)
        do $ File $ object (:data child) (:onClick @onFileClick)
          :key index
          :open @props.open
        do $ FolderFactory $ object (:data child) (:onSelect @onFileClick)
          :key index
          :open @props.open

  :render $ \ ()
    div
      object (:className :folder)
      div
        object (:className :line) (:onClick @onToggle)
        span
          object (:className :icon)
          if @state.isExpanded iconExpanded iconFolded
        span
          object (:className :name)
          , @props.data.name
      if @state.isExpanded
        div
          object (:className :children)
          @renderChildren
        , null

= FolderFactory $ React.createFactory Editor
= module.exports Editor
