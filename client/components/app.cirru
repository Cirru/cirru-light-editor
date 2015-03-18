
= React $ require :react

= Editor $ React.createFactory $ require :cirru-editor
= div $ React.createFactory :div

= module.exports $ React.createClass $ object
  :displayName :App

  :getInitialState $ \ ()
    object
      :ast $ array
      :focus $ array

  :onChange $ \ (ast focus)
    @setState $ object (:ast ast) (:focus focus)

  :render $ \ ()
    div (object)
      Editor $ object
        :ast @state.ast
        :focus @state.focus
        :onChange @onChange
