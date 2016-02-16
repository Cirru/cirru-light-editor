
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable

  ({}~ div input) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-finder

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired

  :getInitialState $ \ ()
    {}
      :text :updater

  :onChange $ \ (event)
    @setState $ {} :text event.target.value

  :renderList $ \ ()
    var
      keys $ ... @state.text
        split ": "
        filter $ \ (piece)
          console.log piece
          > (. (piece.trim) :length) 0
    console.log keys @state.text
    ... @props.collection
      filter $ \\ (file)
        var
          filepath $ file.get :filepath
        or (is keys.length 0)
          keys.some $ \ (key)
            > (filepath.indexOf key) 0
      map $ \\ (file)
        div ({} :style @styleFile) (file.get :filepath)

  :render $ \ ()
    div ({} :style @styleRoot)
      input ({} :style @styleTextbox :value @state.text :onChange @onChange)
      div ({} :style @styleList)
        @renderList

  :styleRoot $ {}
    :color :white
    :background $ hsl 0 0 0
    :position :absolute
    :width :100%
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
    :background :transparent

  :styleFile $ {}
    :fontSize 14
    :lineHeight :40px
    :padding ":0 10px"
    :borderTop $ + ":1px solid " (hsl 0 0 80)
    :cursor :pointer
    :fontFamily ":Menlo, Courier, monospace"

  :styleList $ {}
    :flex 1
    :overflowY :auto
