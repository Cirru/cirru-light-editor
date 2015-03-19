
= React $ require :react

= store $ require :../store

= Editor $ React.createFactory $ require :cirru-editor
= Folder $ React.createFactory $ require :./folder
= div $ React.createFactory :div

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
    @setState $ object
      :open data.fullpath

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast) (:focus focus)

  :render $ \ ()
    div (object (:className :app))
      div
        object (:className :sidebar)
        if @state.tree
          Folder $ object (:data @state.tree) (:onSelect @onSelect)
            :open @state.open
          , undefined
      div
        object (:className :workspace)
        div
          object (:className :header)
        Editor $ object
          :ast @state.ast
          :focus @state.focus
          :onChange @onChange

