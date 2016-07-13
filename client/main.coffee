require 'cirru-editor/style/layout.css'
require './style/editor-tmp.css'
React = require('react')
ReactDOM = require('react-dom')
recorder = require('actions-recorder')
urlParse = require('url-parse')
Immutable = require('immutable')
installDevTools = require('immutable-devtools')
schema = require('./schema')
updater = require('./updater')
analytics = require('./util/analytics')
App = React.createFactory(require('./components/app'))

pageUrl = urlParse(location.toString(), true)
domain = if pageUrl.query? then pageUrl.query.domain or 'localhost' else 'localhost'
port = if pageUrl.query? then pageUrl.query.port or '7001' else '7001'
ws = new WebSocket('ws://' + domain + ':' + port)

send = (type, data) ->
  ws.send JSON.stringify([type, data])

render = (core) ->
  console.log core.get('store').toJS()
  ReactDOM.render App(
    core: core
    send: send), document.querySelector('#app')

installDevTools.default Immutable
recorder.setup
  updater: updater
  initial: schema.db
recorder.request render
recorder.subscribe render

ws.onopen = ->
  analytics.trackAction 'light-editor connected'
  recorder.dispatch 'device/connect'

ws.onclose = ->
  recorder.dispatch 'device/disconnect'

ws.onmessage = (msg) ->
  action = JSON.parse(msg.data)
  console.log 'action:', action
  switch action.type
    when 'sync'
      recorder.dispatch 'collection/sync', action.data
    when 'patch'
      recorder.dispatch 'collection/patch', action.data
  return

if module.hot
  module.hot.accept './components/app', ->
    App = React.createFactory(require('./components/app'))
    recorder.request render
