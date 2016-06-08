
var
  hsl $ require :hsl
  React $ require :react
  keycode $ require :keycode
  Immutable $ require :immutable
  cirruParser $ require :cirru-parser
  cirruWriter $ require :cirru-writer

  analytics $ require :../util/analytics

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
      :baseDirectory :
      :mode :
      :height window.innerHeight
      :clipboard null

  :componentDidMount $ \ ()
    window.addEventListener :keydown @onWindowKeydown
    window.addEventListener :resize @onWindowResize

  :componentWillUnmount $ \ ()
    window.removeEventListener :keydown @onWindowKeydown
    window.removeEventListener :resize @onWindowResize

  :onWindowResize $ \ ()
    @setState $ {} :height window.innerHeight

  :onWindowKeydown $ \ (event)
    if
      and
        or event.metaKey event.ctrlKey
        is (keycode event.keyCode) :p
      do $ if (not event.shiftKey)
        do
          event.preventDefault
          @setState $ {} :mode :finder
        do
          event.preventDefault
          @setState $ {} :mode :commander
    return

  :onFileSelect $ \ (filepath baseDirectory)
    @setState $ {}
      :openFilepath filepath
      :baseDirectory baseDirectory
      :mode :basic
    analytics.trackAction ":open finder"

  :onSaveCirru $ \ (tree)
    var
      isJSON $ ? (@state.openFilepath.match /\.json$)
      text $ cond isJSON
        JSON.stringify tree
        cirruWriter.render (tree.toJS)
    @props.send :update-file $ {}
      :file @state.openFilepath
      :text text
    analytics.trackAction ":save cirru file"

  :onSaveText $ \ (text)
    @props.send :update-file $ {}
      :file @state.openFilepath
      :text text
    analytics.trackAction ":save text file"

  :onClipboard $ \ (expression)
    @setState $ {} :clipboard expression

  :onFinderClose $ \ ()
    @setState $ {} :mode :basic

  :renderEmpty $ \ ()
    div ({} :style @styleEmpty)
      , ":No file is Selected"

  :onSendCommand $ \ (info)
    @setState $ {} :mode :basic
    switch (info.get :command)
      :refresh
        @props.send :refresh
        analytics.trackAction ":open commander"
    return

  :mixpanelTrack $ \ (name props)

  :renderEditor $ \ ()
    var
      filepath @state.openFilepath
      file $ @props.collection.find $ \\ (file)
        is (file.get :filepath) @state.openFilepath
      rawContent $ cond (? file) (file.get :text) :
      fileContent $ cond (is rawContent :) :[] rawContent
      isJSON $ and (? filepath) (? (filepath.match /\.json))
      isCirru $ and (? filepath) (? (filepath.match /\.cirru))

    div ({} :style @styleEditor)
      cond (? @state.openFilepath)
        div ({} :style @styleContainer)
          div ({} :style @styleName)
            @state.openFilepath.replace @state.baseDirectory :
          div ({} :style (@styleBox))
            cond (or isJSON isCirru)
              CirruEditor $ {}
                :tree $ Immutable.fromJS $ cond isJSON
                  JSON.parse fileContent
                  cirruParser.pare fileContent
                :onSave @onSaveCirru
                :key @state.openFilepath
                :height (- @state.height 40)
                :eventTrack @mixpanelTrack
                :clipboard @state.clipboard
                :onClipboard @onClipboard
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
            , :onClose @onFinderClose

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
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"

  :styleName $ {}
    :height 40
    :color $ hsl 0 0 80
    :fontFamily ":Source Code Pro, Menlo, Courier, monospace"
    :fontSize 14
    :lineHeight :40px
    :padding ":0 8px"

  :styleContainer $ {}
    :display :flex
    :flexDirection :column

  :styleBox $ \ ()
    {}
      :flex 1
      :position :relative
      :height $ - @state.height 40
