
var
  hsl $ require :hsl
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable
  ({}~ div input) React.DOM

  commands $ Immutable.fromJS $ []
    {} :command :refresh :text ":Refresh"
    {} :command :noop :text :Noop

= module.exports $ React.createClass $ {}
  :displayName :app-commander

  :propTypes $ {}
    :onSendCommand React.PropTypes.func.isRequired
    :onClose React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {} :text : :selectedIndex 0

  :componentDidMount $ \ ()
    requestAnimationFrame $ \\ ()
      @refs.input.focus

  :filterCommands $ \ ()
    commands.filter $ \\ (commandData)
      var
        textInfo $ ... commandData (get :text) (toLowerCase)
      >= (textInfo.indexOf @state.text) 0

  :onClick $ \ (event)
    event.stopPropagation

  :onKeyDown $ \ (event)
    switch (keycode event.keyCode)
      :down $ @onSelectNext
      :up $ @onSelectPrevious
      :enter $ @onSelectCurrent
      :esc $ @onClose
    return

  :onClose $ \ ()
    @props.onClose

  :onChange $ \ (event)
    @setState $ {} :text event.target.value :selectedIndex 0

  :onSelectNext $ \ ()
    var
      filteredCommands $ @filterCommands
    if (< @state.selectedIndex (- filteredCommands.size 1))
      do $ @setState $ {} :selectedIndex
        + 1 @state.selectedIndex
    return

  :onSelectPrevious $ \ ()
    if (> @state.selectedIndex 0)
      do $ @setState $ {} :selectedIndex
        - @state.selectedIndex 1
    return

  :onSelectCurrent $ \ ()
    var
      filteredCommands $ @filterCommands
      current $ filteredCommands.get @state.selectedIndex

    if (? current)
      do
        @props.onSendCommand current
    return

  :renderList $ \ ()
    var
      filteredCommands $ @filterCommands
    div ({} :style @styleList)
      filteredCommands.map $ \\ (command index)
        var
          onClick $ \\ (event)
            @props.onSendCommand command
          isSelected $ is index @state.selectedIndex
        div ({} :style (@styleCommand isSelected) :onClick onClick :key index)
          command.get :text

  :render $ \ ()
    div ({} :style @styleRoot :onClick @onClick)
      input
        {} :style @styleTextbox :value @state.text :ref :input
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

  :styleCommand $ \ (isSelected) $ {}
    :fontSize 14
    :lineHeight :40px
    :color $ hsl 0 0 70
    :cursor :pointer
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"
    :padding ":0 10px"
    :backgroundColor $ cond isSelected (hsl 0 0 40) (hsl 0 0 0)
