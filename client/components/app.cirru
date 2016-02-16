
var
  React $ require :react
  parser $ require :cirru-parser
  writer $ require :cirru-writer
  Immutable $ require :immutable

  Devtools $ React.createFactory $ require :actions-recorder/lib/devtools
  Editor $ React.createFactory $ require :cirru-editor
  Folder $ React.createFactory $ require :./folder

  div $ React.createFactory :div
  span $ React.createFactory :span
  textarea $ React.createFactory :textarea

= module.exports $ React.createClass $ object
  :displayName :App

  :propTypes $ {}
    :core $ . (React.PropTypes.instanceOf Immutable.Map) :isRequired

  :getInitialState $ \ ()
    {}
      :code ":"
      :open :
      :path $ Immutable.List
      :showDevTools false

  :componentDidMount $ \ ()
    window.addEventListener :keydown @onWindowKeydown

  :componentWillUnmount $ \ ()
    window.removeEventListener :keydown @onWindowKeydown

  :isCirruFile $ \ ()
    ? $ @state.open.match "/\\.cirru$"

  :isCirruMode $ \ ()
    and (@isCirruFile)

  :onSelect $ \ (data)
    var info $ . @state.code data.fullpath
    @setState $ object
      :open data.fullpath
      :ast $ parser.pare info.text
      :text info.text

  :onSave $ \ ()
    if (@isCirruMode)
      do $ actions.update @state.open $ writer.render @state.ast
      do $ actions.update @state.open @state.text
    return

  :onClose $ \ ()
    @setState $ object
      :open :

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast)
      :focus focus
      :text $ writer.render ast

  :onPathChange $ \ (path)
    @setState $ {} :path path

  :onWindowKeydown $ \ (event)
    console.log event
    if
      and event.metaKey event.shiftKey
        is event.key :a
      do
        @setState $ {} :showDevTools $ not @state.showDevTools
    return

  :renderHeader $ \ ()
    var
      info $ . @state.code @state.open
      formatedCode $ cond (@isCirruMode)
        writer.render @state.ast
        , @state.text

    div
      object (:className :header)
      div
        object (:className :name)
        , @state.open
      cond (isnt formatedCode info.text)
        div
          object (:className :button) (:onClick @onSave)
          , :save
      div
        object (:className :button) (:onClick @onClose)
        , :close

  :renderLayer $ \ ()
    div ({} :className :devtools-layer)
      Devtools $ {}
        :core @props.core
        :language :en
        :width window.innerWidth
        :height window.innerHeight
        :path @state.path
        :onPathChange @onPathChange

  :render $ \ ()

    div ({} :className :app)
      cond (and @state.code @state.open)
        div ({} :className :workspace)
          cond (@isCirruMode)
            Editor $ {} :key @state.open :ast @state.ast :focus @state.focus :onChange @onChange

        div ({} :className :workspace)

      div ({} :className :sidebar)
        cond (and @state.code @state.open)
          @renderHeader
        cond @state.tree
          Folder $ {} :data @state.tree :onSelect @onSelect :open @state.open
          div ({} :className :hint) ":Wanting for ws://localhost:7001"
      cond @state.showDevTools
        @renderLayer
