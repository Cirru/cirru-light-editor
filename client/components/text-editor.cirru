
var
  React $ require :react
  ({}~ div textarea) React.DOM

  breaks $ requre :../util/breaks

= module.exports $ React.createClass $ {}
  :displayName :text-editor

  :propTypes $ {}
    :text React.PropTypes.string.isRequired
    :onSave React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    :text @props.text

  :onKeydown $ \ (event)
    if (is event.keyCode 13)
      do
        event.preventDefault
        breaks.manualBreaks event.target
    return

  :onTextChange $ \ (event)
    @setState $ {} :text event.target.value

  :onSave $ \ (event)
    @props.onSave @state.text

  :render $ \ ()
    div ({})
      div ({} :className :editor-tool)
        div ({} :onClick @onSave) ":save"
      textarea $ {} :value @state.text :onChange @onTextChange :onKeyDown @onKeydown
