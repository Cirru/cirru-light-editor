
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable

  ({}~ div input) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-finder

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :onFileSelect React.PropTypes.func.isRequired
    :openFilepath React.PropTypes.string

  :getInitialState $ \ ()
    {}
      :text :

  :onChange $ \ (event)
    @setState $ {} :text event.target.value

  :onSelect $ \ (file)
    @props.onFileSelect (file.get :filepath)

  :renderList $ \ ()
    var
      keys $ ... @state.text
        split ": "
        filter $ \ (piece)
          > (. (piece.trim) :length) 0
    ... @props.collection
      filter $ \\ (file)
        var
          filepath $ file.get :filepath
        or (is keys.length 0)
          keys.some $ \ (key)
            > (filepath.indexOf key) 0
      map $ \\ (file)
        var
          onSelect $ \\ ()
            @onSelect file
        div
          {}
            :style $ @styleFile $ is @props.openFilepath (file.get :filepath)
            :key (file.get :filepath)
            :onClick onSelect
          ... (file.get :filepath)
            replace (file.get :baseDirectory) :

  :render $ \ ()
    div ({} :style @styleRoot)
      input ({} :style @styleTextbox :value @state.text :onChange @onChange :autoFocus true)
      div ({} :style @styleList)
        @renderList

  :styleRoot $ {}
    :color :white
    :background $ hsl 316 12 19
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
    :fontFamily ":Menlo, Courier, monospace"
    :padding ":0 10px"
    :fontSize 14
    :color :white
    :background $ hsl 0 0 100 0.2

  :styleFile $ \ (isSelected) $ {}
    :fontSize 14
    :lineHeight :40px
    :padding ":0 10px"
    :borderTop $ + ":1px solid " (hsl 0 0 30)
    :cursor :pointer
    :fontFamily ":Menlo, Courier, monospace"
    :backgroundColor $ cond isSelected
      hsl 0 0 20
      , :transparent
    :whiteSpace :nowrap
    :overflowX :hidden
    :textOverflow :ellipsis

  :styleList $ {}
    :flex 1
    :overflowY :auto
    :paddingBottom 200
