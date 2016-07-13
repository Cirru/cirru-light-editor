hsl = require('hsl')
React = require('react')
keycode = require('keycode')
Immutable = require('immutable')
cirruParser = require('cirru-parser')
vectorsFormat = require('cirru-vectors-format')
cirruWriter = require('cirru-writer')
analytics = require('../util/analytics')

Finder = React.createFactory(require('./finder'))
Commander = React.createFactory(require('./commander'))
TextEditor = React.createFactory(require('./text-editor'))
CirruEditor = React.createFactory(require('cirru-editor'))

{div, a} = React.DOM

guideUrl = 'https://github.com/Cirru/cirru-light-editor/wiki/Start-using-Cirru-Editor'

module.exports = React.createClass(
  displayName: 'app-workspace'

  propTypes:
    collection: React.PropTypes.instanceOf(Immutable.List).isRequired
    send: React.PropTypes.func.isRequired

  getInitialState: ->
    openFilepath: null
    baseDirectory: ''
    mode: ''
    height: window.innerHeight
    clipboard: null

  componentDidMount: ->
    window.addEventListener 'keydown', @onWindowKeydown
    window.addEventListener 'resize', @onWindowResize

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @onWindowKeydown
    window.removeEventListener 'resize', @onWindowResize

  onWindowResize: ->
    @setState height: window.innerHeight

  onWindowKeydown: (event) ->
    if (event.metaKey or event.ctrlKey) and keycode(event.keyCode) == 'p'
      if !event.shiftKey
        event.preventDefault()
        @setState mode: 'finder'
      else
        event.preventDefault()
        @setState mode: 'commander'

  onFileSelect: (filepath, baseDirectory) ->
    @setState
      openFilepath: filepath
      baseDirectory: baseDirectory
      mode: 'basic'
    analytics.trackAction 'open finder'

  onSaveCirru: (tree) ->
    isJSON = @state.openFilepath.match(/\.json$/) != null
    isEDN = @state.openFilepath.match(/\.ir$/) != null
    text =
      if isJSON then JSON.stringify(tree)
      else if isEDN then vectorsFormat.write(tree.toJS())
      else cirruWriter.render(tree.toJS())
    @props.send 'update-file',
      file: @state.openFilepath
      text: text
    analytics.trackAction 'save cirru file'

  onSaveText: (text) ->
    @props.send 'update-file',
      file: @state.openFilepath
      text: text
    analytics.trackAction 'save text file'

  onClipboard: (expression) ->
    @setState clipboard: expression

  onFinderClose: ->
    @setState mode: 'basic'

  renderEmpty: ->
    div {style: @styleEmpty},
      div({}, '`Command + p` for file finder')
      div({}, '`Command + Shift + p` for commands')

  onSendCommand: (info) ->
    @setState mode: 'basic'
    switch info.get('command')
      when 'refresh'
        @props.send 'refresh'
        analytics.trackAction 'open commander'
    return

  mixpanelTrack: (name, props) ->

  renderEditor: ->
    filepath = @state.openFilepath
    file = @props.collection.find (file) =>
      file.get('filepath') is @state.openFilepath

    rawContent = if file? then file.get('text') else ''
    fileContent = if rawContent == '' then '[]' else rawContent
    isEDN = filepath? and filepath.match(/\.ir/)?
    isJSON = filepath? and filepath.match(/\.json/)?
    isCirru = filepath? and filepath.match(/\.cirru/)?

    div style: @styleEditor,
      if @state.openFilepath?
        div style: @styleContainer,
          div style: @styleName,
            @state.openFilepath.replace(@state.baseDirectory, ''),
            a style: @styleGuide, href: guideUrl, target: '_blanck', 'Guide'
          div style: @styleBox(),
            if isJSON or isCirru or isEDN
              data =
                if isJSON then JSON.parse(fileContent)
                else if isEDN then (vectorsFormat.parse(fileContent).data or [])
                else cirruParser.pare(fileContent)

              CirruEditor
                tree: Immutable.fromJS(data)
                onSave: @onSaveCirru
                key: @state.openFilepath
                height: @state.height - 40
                eventTrack: @mixpanelTrack
                clipboard: @state.clipboard
                onClipboard: @onClipboard
            else
              TextEditor
                text: file.get('text')
                onSave: @onSaveText
                key: @state.openFilepath
      else @renderEmpty()

  renderOverlay: ->
    div style: @styleOverlay, onClick: @onFinderClose,
      switch @state.mode
        when 'finder'
          Finder
            collection: @props.collection
            onFileSelect: @onFileSelect
            openFilepath: @state.openFilepath
            onClose: @onFinderClose
        when 'commander'
          Commander
            onSendCommand: @onSendCommand
            onClose: @onFinderClose
  render: ->
    div style: @styleRoot,
      @renderEditor()
      if @state.mode isnt 'basic' then @renderOverlay()

  styleRoot:
    position: 'absolute'
    top: 0
    left: 0
    width: '100%'
    height: '100%'

  styleOverlay:
    backgroundColor: hsl(0, 80, 10, 0.3)
    width: 400
    position: 'absolute'
    zIndex: 10
    left: 0
    top: 0
    width: '100%'
    height: '100%'
    display: 'flex'
    flexDirection: 'row'
    justifyContent: 'center'

  styleEditor:
    backgroundColor: hsl(200, 40, 0)
    position: 'absolute'
    color: 'white'
    width: '100%'
    height: '100%'
    top: 0
    left: 0

  styleEmpty:
    color: 'white'
    position: 'absolute'
    width: '100%'
    height: '100%'
    display: 'flex'
    flexDirection: 'column'
    justifyContent: 'center'
    alignItems: 'center'
    fontFamily: 'Source Code Pro, Menlo, Courier, monospace'
    lineHeight: 2
    fontSize: 14

  styleName:
    height: 40
    color: hsl(0, 0, 80)
    fontFamily: 'Source Code Pro, Menlo, Courier, monospace'
    fontSize: 14
    lineHeight: '40px'
    padding: '0 8px'
    display: 'flex'
    flexDirection: 'row'
    justifyContent: 'space-between'

  styleContainer:
    display: 'flex'
    flexDirection: 'column'

  styleBox: ->
    flex: 1
    position: 'relative'
    height: @state.height - 40

  styleGuide:
    color: hsl(200, 90, 40)
    fontSize: 12)
