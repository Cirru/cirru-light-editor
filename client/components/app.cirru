
var
  React $ require :react
  parser $ require :cirru-parser
  writer $ require :cirru-writer
  Immutable $ require :immutable

  mixinBreaks $ require :../mixins/breaks

  Editor $ React.createFactory $ require :cirru-editor
  Folder $ React.createFactory $ require :./folder
  div $ React.createFactory :div
  span $ React.createFactory :span
  textarea $ React.createFactory :textarea

= module.exports $ React.createClass $ object
  :displayName :App
  :mixins $ array mixinBreaks

  :propTypes $ {}
    :core $ . (React.PropTypes.instanceOf Immutable.Map) :isRequired

  :getInitialState $ \ ()
    {}
      :code ":"
      :open :

  :isCirruFile $ \ ()
    ? $ @state.open.match "/\\.cirru$"

  :isCirruMode $ \ ()
    and (@isCirruFile) (not @state.fallback)

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

  :onTextChange $ \ (event)
    if (@isCirruFile)
      do $ @setState $ object
        :text event.target.value
        :ast $ parser.pare event.target.value
      do $ @setState $ object
        :text event.target.value
    return

  :onFallbackToggle $ \ ()
    @setState $ object
      :fallback $ not @state.fallback

  :onTextKeydown $ \ (event)
    if (is event.keyCode 13)
      do
        event.preventDefault
        @manualBreaks event.target
        @onTextChange event
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
      cond (@isCirruFile) $ div
        object (:className :button) (:onClick @onFallbackToggle)
        + :text: (cond @state.fallback :on :off)
      div
        object (:className :button) (:onClick @onClose)
        , :close

  :render $ \ ()

    div ({} :className :app)
      cond (and @state.code @state.open)
        div ({} :className :workspace)
          cond (@isCirruMode)
            Editor $ {} :key @state.open :ast @state.ast :focus @state.focus :onChange @onChange
            textarea $ {} :key @state.open :value @state.text :onChange @onTextChange :onKeyDown @onTextKeydown
        div ({} :className :workspace)

      div ({} :className :sidebar)
        cond (and @state.code @state.open)
          @renderHeader
        cond @state.tree
          Folder $ {} :data @state.tree :onSelect @onSelect :open @state.open
          div ({} :className :hint) ":Wanting for ws://localhost:7001"
