
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable
  ({}~ div input) React.DOM

  commands $ Immutable.fromJS $ []
    {} :command :refresh :text ":Refresh"

= module.exports $ React.createClass $ {}
  :displayName :app-commander

  :propTypes $ {}
    :onSendCommand React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {} :text :

  :onClick $ \ (event)
    event.stopPropagation

  :onChange $ \ (event)

  :onKeyDown $ \ (event)

  :onChange $ \ (event)
    @setState $ {} :text event.target.value :selectedIndex 0

  :renderList $ \ ()
    div ({} :style @styleList)
      commands.map $ \\ (command index)
        var
          onClick $ \\ (event)
            @props.onSendCommand command
        div ({} :style @styleCommand :onClick onClick :key index)
          command.get :text

  :render $ \ ()
    div ({} :style @styleRoot :onClick @onClick)
      input
        {} :style @styleTextbox :value @state.text
          , :onChange @onChange :ref :input :onKeyDown @onKeyDown
      @renderList

  :styleRoot $ {}
    :width :80%
    :height :100%
    :position :relative
    :display :flex
    :flexDirection :column
    :background $ hsl 316 12 10 0.9

  :styleList $ {}

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

  :styleCommand $ {}
    :fontSize 14
    :lineHeight :40px
    :color $ hsl 0 0 70
    :cursor :pointer
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"
    :padding ":0 10px"
