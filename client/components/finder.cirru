
var
  hsl $ require :hsl
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable

  analytics $ require :../util/analytics

  ({}~ div input) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-finder

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :onFileSelect React.PropTypes.func.isRequired
    :openFilepath React.PropTypes.string
    :onClose React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {}
      :text :
      :selectedIndex 0

  :componentDidMount $ \ ()
    requestAnimationFrame $ \\ ()
      @refs.input.focus

  :selectNext $ \ ()
    var
      files $ @filterFiles
    if (< @state.selectedIndex (- files.size 1))
      do $ @setState $ {} :selectedIndex
        + 1 @state.selectedIndex
    return

  :selectPrevious $ \ ()
    if (> @state.selectedIndex 0)
      do $ @setState $ {} :selectedIndex
        - @state.selectedIndex 1
    return

  :selectCurrent $ \ ()
    var
      files $ @filterFiles
      current $ files.get @state.selectedIndex
    if (? current) $ do
      @onSelect current
    analytics.trackAction ":keyboard select file"
    return

  :filterFiles $ \ ()
    var
      keys $ ... @state.text
        split ": "
        filter $ \ (piece)
          > (. (piece.trim) :length) 0
    @props.collection.filter $ \\ (file)
      var
        filepath $ ... file
          get :filepath
          replace (file.get :baseDirectory) :
      or (is keys.length 0)
        keys.every $ \ (key)
          >= (filepath.indexOf key) 0

  :onChange $ \ (event)
    @setState $ {} :text event.target.value :selectedIndex 0

  :onSelect $ \ (file)
    @props.onFileSelect (file.get :filepath)

  :onClose $ \ ()
    @props.onClose

  :onKeyDown $ \ (event)
    switch (keycode event.keyCode)
      :down
        @selectNext
      :up
        @selectPrevious
      :enter
        @selectCurrent
      :esc
        @onClose
    return

  :onClick $ \ (event)
    event.stopPropagation

  :renderList $ \ ()
    var
      files $ @filterFiles
    files.map $ \\ (file index)
      var
        onSelect $ \\ ()
          @onSelect file
          analytics.trackAction ":click select file"
      div
        {}
          :style $ @styleFile
            is @props.openFilepath (file.get :filepath)
            is index @state.selectedIndex
          :key (file.get :filepath)
          :onClick onSelect
        ... (file.get :filepath)
          replace (file.get :baseDirectory) :

  :render $ \ ()
    div ({} :style @styleRoot :onClick @onClick)
      input
        {} :style @styleTextbox :value @state.text
          , :onChange @onChange :ref :input :onKeyDown @onKeyDown
      div ({} :style @styleList)
        @renderList

  :styleRoot $ {}
    :color :white
    :background $ hsl 316 12 10 0.9
    :width :80%
    :height :100%
    :display :flex
    :flexDirection :column

  :styleTextbox $ {}
    :display :block
    :width :100%
    :border :none
    :lineHeight :40px
    :outline :none
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"
    :padding ":0 10px"
    :fontSize 14
    :color :white
    :background $ hsl 0 0 100 0.2

  :styleFile $ \ (isOpen isSelected) $ {}
    :fontSize 14
    :lineHeight :40px
    :padding ":0 10px"
    :borderTop $ + ":1px solid " (hsl 0 0 16)
    :cursor :pointer
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"
    :backgroundColor $ cond isSelected
      hsl 0 0 40
      hsl 0 0 10
    :color $ cond isOpen
      hsl 0 0 100
      hsl 0 0 70
    :whiteSpace :nowrap
    :overflowX :hidden
    :textOverflow :ellipsis

  :styleList $ {}
    :flex 1
    :overflowY :auto
    :paddingBottom 200
