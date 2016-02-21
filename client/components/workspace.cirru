
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable
  cirruParser $ require :cirru-parser
  cirruWriter $ require :cirru-writer

  Finder $ React.createFactory $ require :./finder
  Commander $ React.createFactory $ require :./commander
  TextEditor $ React.createFactory $ require :./text-editor
  CirruEditor $ React.createFactory $ require :cirru-editor

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-workspace

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired
    :send React.PropTypes.func.isRequired

  :getInitialState $ \ ()
    {}
      :openFilepath null
      :mode :

  :componentDidMount $ \ ()
    window.addEventListener :keydown @onWindowKeydown

  :componentWillUnmount $ \ ()
    window.removeEventListener :keydown @onWindowKeydown

  :onWindowKeydown $ \ (event)
    if
      and event.metaKey (is event.key :p)
      do $ if (not event.shiftKey)
        do
          event.preventDefault
          @setState $ {} :mode :finder
        do
          event.preventDefault
          @setState $ {} :mode :commander
    return

  :onFileSelect $ \ (filepath)
    @setState $ {}
      :openFilepath filepath
      :mode :basic

  :onSaveCirru $ \ (tree)
    var
      text $ cirruWriter.render (tree.toJS)
    @props.send :update-file $ {}
      :file @state.openFilepath
      :text text

  :onSaveText $ \ (text)
    @props.send :update-file $ {}
      :file @state.openFilepath
      :text text

  :onFinderClose $ \ ()
    @setState $ {} :mode :basic

  :renderEmpty $ \ ()
    div ({} :style @styleEmpty)
      , ":No file is Selected"

  :onSendCommand $ \ (info)
    @setState $ {} :mode :basic
    @props.send :refresh

  :renderEditor $ \ ()
    var
      file $ @props.collection.find $ \\ (file)
        is (file.get :filepath) @state.openFilepath

    div ({} :style @styleEditor)
      cond (? @state.openFilepath)
        div ({} :style @styleContainer)
          div ({} :style @styleName) @state.openFilepath
          div ({} :style @styleBox)
            cond (? $ @state.openFilepath.match /\.cirru$)
              CirruEditor $ {}
                :tree $ Immutable.fromJS $ cirruParser.pare (file.get :text)
                :onSave @onSaveCirru
                :key @state.openFilepath
                :height (- window.innerHeight 40)
              TextEditor $ {} :text (file.get :text) :onSave @onSaveText
                , :key @state.openFilepath
        @renderEmpty

  :renderOverlay $ \ ()
    div ({} :style @styleOverlay :onClick @onFinderClose)
      case @state.mode
        :finder
          Finder $ {} :collection @props.collection :onFileSelect @onFileSelect
            , :openFilepath @state.openFilepath :onClose @onFinderClose
        :commander
          Commander $ {} :onSendCommand @onSendCommand

  :render $ \ ()
    div ({} :style @styleRoot)
      @renderEditor
      cond (isnt @state.mode :basic)
        @renderOverlay

  :styleRoot $ {}
    :position :absolute
    :top 0
    :left 0
    :width :100%
    :height :100%

  :styleOverlay $ {}
    :backgroundColor $ hsl 0 80 10 0.3
    :width 400
    :position :absolute
    :zIndex 10
    :left 0
    :top 0
    :width :100%
    :height :100%
    :display :flex
    :flexDirection :row
    :justifyContent :center

  :styleEditor $ {}
    :backgroundColor $ hsl 200 40 0
    :position :absolute
    :color :white
    :width :100%
    :height :100%
    :top 0
    :left 0

  :styleEmpty $ {}
    :color :white
    :position :absolute
    :width :100%
    :height :100%
    :display :flex
    :flexDirection :row
    :justifyContent :center
    :alignItems :center

  :styleName $ {}
    :height 40
    :color $ hsl 0 0 80
    :fontFamily ":Menlo, Courier, monospace"
    :fontSize 14
    :lineHeight :40px
    :padding ":0 8px"

  :styleContainer $ {}
    :display :flex
    :flexDirection :column

  :styleBox $ {}
    :flex 1
    :position :relative
    :height $ - window.innerHeight 40
