
= React $ require :react
= parser $ require :cirru-parser

= store $ require :../store
= actions $ require :../actions

= Editor $ React.createFactory $ require :cirru-editor
= Folder $ React.createFactory $ require :./folder
= div $ React.createFactory :div
= span $ React.createFactory :span

= module.exports $ React.createClass $ object
  :displayName :App

  :getInitialState $ \ ()
    object
      :ast $ array
      :focus $ array
      :code $ store.getCode
      :tree $ store.getTree
      :open :

  :componentDidMount $ \ ()
    store.dispatcher.addListener :change @setData

  :componentWillUnmount $ \ ()
    store.dispatcher.removeListener :change @setData

  :setData $ \ ()
    @setState $ object
      :code $ store.getCode
      :tree $ store.getTree

  :onSelect $ \ (data)
    = info $ . @state.code data.fullpath
    @setState $ object
      :open data.fullpath
      :ast $ parser.pare info.text

  :onSave $ \ ()
    actions.update @state.open @state.ast

  :onClose $ \ ()
    @setState $ object
      :open :

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast) (:focus focus)

  :render $ \ ()
    if (not $ and (? @state.code) (? @state.tree))
      do $ return (div)
    = info $ . @state.code @state.open

    div (object (:className :app))
      div
        object (:className :sidebar)
        if @state.tree
          Folder $ object (:data @state.tree) (:onSelect @onSelect)
            :open @state.open
          , undefined
      if (? info)
        div
          object (:className :workspace)
          div
            object (:className :header)
            span
              object (:className :name)
              , @state.open
            span
              object (:className :button) (:onClick @onSave)
              , :save
            span
              object (:className :button) (:onClick @onClose)
              , :close
          Editor $ object
            :key @state.open
            :ast @state.ast
            :focus @state.focus
            :onChange @onChange
        , null
