
var
  React $ require :react
  Immutable $ require :immutable

  Devtools $ React.createFactory $ require :actions-recorder/lib/devtools
  Workspace $ React.createFactory $ require :./workspace
  Connecting $ React.createFactory $ require :./connecting

  ({}~ div) React.DOM

= module.exports $ React.createClass $ object
  :displayName :App

  :propTypes $ {}
    :core $ . (React.PropTypes.instanceOf Immutable.Map) :isRequired
    :send React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {}
      :path $ Immutable.List
      :showDevTools false

  :componentDidMount $ \ ()
    window.addEventListener :keydown @onWindowKeydown

  :componentWillUnmount $ \ ()
    window.removeEventListener :keydown @onWindowKeydown

  :onPathChange $ \ (path)
    @setState $ {} :path path

  :onWindowKeydown $ \ (event)
    if
      and (or event.metaKey event.ctrlKey) event.shiftKey
        is event.key :a
      do
        event.preventDefault
        @setState $ {} :showDevTools $ not @state.showDevTools
    return

  :renderLayer $ \ ()
    div ({} :style @styleLayer)
      Devtools $ {}
        :core @props.core
        :language :en
        :width window.innerWidth
        :height window.innerHeight
        :path @state.path
        :onPathChange @onPathChange

  :render $ \ ()
    var
      store $ @props.core.get :store
      isConnected $ store.getIn $ [] :device :isConnected

    div ({} :className :app :style @styleRoot)
      cond isConnected
        Workspace $ {} :collection (store.get :collection) :send @props.send
        Connecting
      cond @state.showDevTools
        @renderLayer

  :styleRoot $ {}
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"

  :styleLayer $ {}
    :position :absolute
    :top 0
    :left 0
    :width :100%
    :height :100%
