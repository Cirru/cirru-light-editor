React = require('react')
Immutable = require('immutable')
Devtools = React.createFactory(require('actions-recorder/lib/devtools'))
Workspace = React.createFactory(require('./workspace'))
Connecting = React.createFactory(require('./connecting'))

{div} = React.DOM

module.exports = React.createClass
  displayName: 'App'

  propTypes:
    core: React.PropTypes.instanceOf(Immutable.Map).isRequired
    send: React.PropTypes.func.isRequired

  getInitialState: ->
    path: Immutable.List()
    showDevTools: false

  componentDidMount: ->
    window.addEventListener 'keydown', @onWindowKeydown

  componentWillUnmount: ->
    window.removeEventListener 'keydown', @onWindowKeydown

  onPathChange: (path) ->
    @setState path: path

  onWindowKeydown: (event) ->
    if (event.metaKey or event.ctrlKey) and event.shiftKey and event.key == 'a'
      event.preventDefault()
      @setState showDevTools: !@state.showDevTools
    if (event.metaKey or event.ctrlKey) and event.keyCode == 221
      event.preventDefault()

  renderLayer: ->
    div style: @styleLayer,
      Devtools
        core: @props.core
        language: 'en'
        width: window.innerWidth
        height: window.innerHeight
        path: @state.path
        onPathChange: @onPathChange

  render: ->
    store = @props.core.get('store')
    isConnected = store.getIn(['device', 'isConnected'])

    div className: 'app', style: @styleRoot,
      if isConnected
        Workspace collection: store.get('collection'), send: @props.send
      else
        Connecting(device: store.get('device'))
      if @state.showDevTools then @renderLayer()

  styleRoot: fontFamily: 'Source Code Pro, Menlo, Courier, monospace'

  styleLayer:
    position: 'absolute'
    top: 0
    left: 0
    width: '100%'
    height: '100%'
