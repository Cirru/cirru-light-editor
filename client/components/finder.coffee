hsl = require('hsl')
React = require('react')
keycode = require('keycode')
Immutable = require('immutable')
analytics = require('../util/analytics')
{div, input} = React.DOM

module.exports = React.createClass(
  displayName: 'app-finder'

  propTypes:
    collection: React.PropTypes.instanceOf(Immutable.List).isRequired
    onFileSelect: React.PropTypes.func.isRequired
    openFilepath: React.PropTypes.string
    onClose: React.PropTypes.func.isRequired

  getInitialState: ->
    text: ''
    selectedIndex: 0

  componentDidMount: ->
    requestAnimationFrame =>
      @refs.input.focus()

  selectNext: ->
    files = @filterFiles()
    if @state.selectedIndex < files.size - 1
      @setState selectedIndex: 1 + @state.selectedIndex

  selectPrevious: ->
    if @state.selectedIndex > 0
      @setState selectedIndex: @state.selectedIndex - 1

  selectCurrent: ->
    files = @filterFiles()
    current = files.get(@state.selectedIndex)
    if current != null
      @onSelect current
    analytics.trackAction 'keyboard select file'

  filterFiles: ->
    keys = @state.text.split(' ').filter (piece) =>
      piece.trim().length > 0

    @props.collection.filter (file) ->
      filepath = file.get('filepath').replace(file.get('baseDirectory'), '')
      keys.length is 0 or keys.every (key) =>
        filepath.indexOf(key) >= 0

  onChange: (event) ->
    @setState
      text: event.target.value
      selectedIndex: 0

  onSelect: (file) ->
    @props.onFileSelect file.get('filepath'), file.get('baseDirectory')

  onClose: ->
    @props.onClose()

  onKeyDown: (event) ->
    switch keycode(event.keyCode)
      when 'down'
        @selectNext()
      when 'up'
        @selectPrevious()
      when 'enter'
        @selectCurrent()
      when 'esc'
        @onClose()

  onClick: (event) ->
    event.stopPropagation()

  renderList: ->
    files = @filterFiles()
    files.map (file, index) =>
      onSelect = =>
        @onSelect file
        analytics.trackAction 'click select file'

      div
        style: @styleFile(@props.openFilepath == file.get('filepath'), index == @state.selectedIndex)
        key: file.get('filepath')
        onClick: onSelect
        file.get('filepath').replace(file.get('baseDirectory'), '')

  render: ->
    div style: @styleRoot, onClick: @onClick,
      input
        style: @styleTextbox
        value: @state.text
        onChange: @onChange
        ref: 'input'
        onKeyDown: @onKeyDown
      div style: @styleList,
        @renderList()

  styleRoot:
    color: 'white'
    background: hsl(316, 12, 10, 0.9)
    width: '80%'
    height: '100%'
    display: 'flex'
    flexDirection: 'column'

  styleTextbox:
    display: 'block'
    width: '100%'
    border: 'none'
    lineHeight: '40px'
    outline: 'none'
    fontFamily: 'Source Code Pro, Menlo, Courier, monospace'
    padding: '0 10px'
    fontSize: 14
    color: 'white'
    background: hsl(0, 0, 100, 0.2)

  styleFile: (isOpen, isSelected) ->
    fontSize: 14
    lineHeight: '40px'
    padding: '0 10px'
    cursor: 'pointer'
    fontFamily: 'Source Code Pro, Menlo, Courier, monospace'
    backgroundColor: if isSelected then hsl(0, 0, 20) else hsl(0, 0, 10)
    color: if isOpen then hsl(0, 0, 100) else hsl(0, 0, 60)
    whiteSpace: 'nowrap'
    overflowX: 'hidden'
    textOverflow: 'ellipsis'

  styleList:
    flex: 1
    overflowY: 'auto'
    paddingBottom: 200)
