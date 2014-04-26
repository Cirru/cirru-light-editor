
client = require 'ws-json-browser'
{$} = require 'zepto-browserify'

{Editor} = require 'cirru-editor'

listModel =
  $el: $('#files')
  files: []  
  bind: (handle) ->
    @$el.on 'click', '.filename', (event) ->
      handle $(@).data('file')
      return

  render: ->
    html = @files
    .map (name) =>
      "<div class='filename' data-file='#{name}'>#{name}</div>"
    .join('')
    @$el.html html

fileModel =
  name: undefined
  editor: undefined
  focused: yes
  changeFile: (name) ->
    @name = name
    $('#filename').text name
  val: ->
    name: @name, ast: @editor.val()

window.addEventListener 'focus', ->
  fileModel.focused = yes

window.addEventListener 'blur', ->
  fileModel.focused = no

client.connect 'localhost', 7001, (ws) ->

  loadFile = (name) ->
    return if name is fileModel.name
    ws.emit 'get-file', name, (ast) ->
      fileModel.changeFile name
      if fileModel.editor?
        $('#wrap').html('')
        fileModel.editor = null
      fileModel.editor = new Editor
      fileModel.editor.val ast
      $('#wrap').append fileModel.editor.el

  reloadFile = ->
    name = fileModel.name
    fileModel.name = undefined
    loadFile name

  listModel.bind (filename) ->
    loadFile filename

  ws.emit 'get-list'
  ws.on 'get-list', (list) ->
    listModel.files = list
    listModel.render()

  ws.on 'file-change', (name) ->
    if fileModel.name is name
      unless fileModel.focused
        reloadFile()

  $('#save').click ->
    if fileModel.editor?
      ws.emit 'save-file', fileModel.val()

  $('#reload').click ->
    if fileModel.editor?
      reloadFile()