hsl = require('hsl')
React = require('react')
{div, textarea} = React.DOM
breaks = require('../util/breaks')

module.exports = React.createClass
  displayName: 'text-editor'

  propTypes:
    text: React.PropTypes.string.isRequired
    onSave: React.PropTypes.func.isRequired

  getInitialState: ->
    text: @props.text

  onKeydown: (event) ->
    if event.keyCode == 13
      event.preventDefault()
      breaks.manualBreaks event.target

  onTextChange: (event) ->
    @setState text: event.target.value

  onSave: (event) ->
    @props.onSave @state.text

  render: ->
    div style: @styleRoot,
      div style: @styleToolbar,
        if @props.text isnt @state.text
          div style: @styleButton, onClick: @onSave, 'save'
        textarea
          value: @state.text
          onChange: @onTextChange
          onKeyDown: @onKeydown
          style: @styleEditor

  styleRoot:
    display: 'flex'
    flexDirection: 'column'
    position: 'absolute'
    width: '100%'
    height: '100%'
  styleToolbar:
    height: '40'
    display: 'flex'
    flexDirection: 'row'
    alignItems: 'center'
    flexShrink: 0
  styleEditor:
    flex: 1
    backgroundColor: 'transparent'
    color: 'white'
    border: 'none'
    outline: 'none'
    fontFamily: 'Source Code Pro, Menlo, Courier, monospace'
    fontSize: 14
    lineHeight: '24px'
  styleButton:
    backgroundColor: hsl(0, 50, 60)
    padding: '0 6px'
    lineHeight: '20px'
    fontSize: 12
    borderRadius: 4
    cursor: 'pointer'
