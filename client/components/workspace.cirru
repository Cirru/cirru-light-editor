
var
  hsl $ require :hsl
  React $ require :react
  Immutable $ require :immutable
  cirruParser $ require :cirru-parser

  Finder $ React.createFactory $ require :./finder
  TextEditor $ React.createFactory $ require :./text-editor
  CirruEditor $ React.createFactory $ require :cirru-editor

  ({}~ div) React.DOM

= module.exports $ React.createClass $ {}
  :displayName :app-workspace

  :propTypes $ {}
    :collection $ . (React.PropTypes.instanceOf Immutable.List) :isRequired

  :getInitialState $ \ ()
    {}
      :openFilepath null
      :tree (Immutable.List)
      :text :

  :onFileSelect $ \ (filepath)
    var
      file $ @props.collection.find $ \\ (file)
        is (file.get :filepath) filepath
    @setState $ {}
      :openFilepath filepath
      :tree $ cond (? file)
        Immutable.fromJS $ cirruParser.pare (file.get :text)
      :text $ file.get :text

  :onSaveCirru $ \ (tree)
    console.log :save tree

  :onSaveText $ \ (text)
    console.log :text text

  :renderEmpty $ \ ()
    div ({} :style @styleEmpty)
      , ":No file is Selected"

  :renderEditor $ \ ()
    div ({} :style @styleEditor)
      cond (? @state.openFilepath)
        cond (? $ @state.openFilepath.match /\.cirru$)
          CirruEditor $ {} :tree @state.tree :onSave @onSaveCirru
            , :key @state.openFilepath :height window.innerHeight
          TextEditor $ {} :text @state.text :onSave @onSaveText
            , :key @state.openFilepath
        @renderEmpty

  :renderSidebar $ \ ()
    div ({} :style @styleSidebar)
      Finder $ {} :collection @props.collection :onFileSelect @onFileSelect

  :render $ \ ()
    div ({} :style @styleRoot)
      @renderEditor
      @renderSidebar

  :styleRoot $ {}
    :position :absolute
    :top 0
    :left 0
    :width :100%
    :height :100%
    :display :flex
    :flexDirection :row
    :alignItems :stretch
    :justifyContent :center
    :fontFamily ":Verdana"

  :styleSidebar $ {}
    :backgroundColor $ hsl 0 80 100
    :width 400
    :position :relative

  :styleEditor $ {}
    :backgroundColor $ hsl 200 40 0
    :flex 1
    :position :relative
    :color :white

  :styleEmpty $ {}
    :color :white
    :position :absolute
    :width :100%
    :height :100%
    :display :flex
    :flexDirection :row
    :justifyContent :center
    :alignItems :center
