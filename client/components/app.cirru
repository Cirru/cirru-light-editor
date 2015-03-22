
= React $ require :react
= parser $ require :cirru-parser
= writer $ require :cirru-writer

= store $ require :../store
= actions $ require :../actions

= Editor $ React.createFactory $ require :cirru-editor
= Folder $ React.createFactory $ require :./folder
= div $ React.createFactory :div
= span $ React.createFactory :span
= textarea $ React.createFactory :textarea

= module.exports $ React.createClass $ object
  :displayName :App

  :getInitialState $ \ ()
    object
      :ast $ array
      :focus $ array
      :code $ store.getCode
      :tree $ store.getTree
      :open :
      :text :
      :fallback false

  :componentDidMount $ \ ()
    store.dispatcher.addListener :change @setData

  :componentWillUnmount $ \ ()
    store.dispatcher.removeListener :change @setData

  :setData $ \ ()
    @setState $ object
      :code $ store.getCode
      :tree $ store.getTree

  :isCirruFile $ \ ()
    ? $ @state.open.match "/\\.cirru$"

  :isCirruMode $ \ ()
    and (@isCirruFile) (not @state.fallback)

  :onSelect $ \ (data)
    = info $ . @state.code data.fullpath
    @setState $ object
      :open data.fullpath
      :ast $ parser.pare info.text
      :text info.text

  :onSave $ \ ()
    if (@isCirruMode)
      do $ actions.update @state.open $ writer.render @state.ast
      do $ actions.update @state.open @state.text

  :onClose $ \ ()
    @setState $ object
      :open :

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast)
      :focus focus
      :text $ writer.render ast

  :onTextChange $ \ (event)
    if (@isCirruFile)
      do $ @setState $ object
        :text event.target.value
        :ast $ parser.pare event.target.value
      do $ @setState $ object
        :text event.target.value

  :onFallbackToggle $ \ ()
    @setState $ object
      :fallback $ not @state.fallback

  :render $ \ ()
    if (not $ and (? @state.code) (? @state.tree))
      do $ return (div)
    = info $ . @state.code @state.open
    if (@isCirruMode)
      do $ = formatedCode $ writer.render @state.ast
      do $ = formatedCode @state.text

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
            if (isnt formatedCode info.text)
              span
                object (:className :button) (:onClick @onSave)
                , :save
            if (@isCirruFile) $ span
              object (:className :button) (:onClick @onFallbackToggle)
              ++: :text: (if @state.fallback :on :off)
            span
              object (:className :button) (:onClick @onClose)
              , :close
          if (@isCirruMode)
            Editor $ object
              :key @state.open
              :ast @state.ast
              :focus @state.focus
              :onChange @onChange
            textarea $ object
              :key @state.open
              :value @state.text
              :onChange @onTextChange
        , null
