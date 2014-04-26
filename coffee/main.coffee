
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
    $('.filename.open').removeClass 'open'
    $(".filename[data-file='#{name}']").addClass 'open'
  val: ->
    name: @name, ast: @editor.val()

window.addEventListener 'focus', ->
  fileModel.focused = yes

window.addEventListener 'blur', ->
  fileModel.focused = no

$('#filter').on 'input', (event) ->
  query = $(@).val()
  $('.filename').each (i, item) ->
    status = $(item).data('file').indexOf(query) < 0
    $(item).toggleClass 'exclude', status

console.log $('#filter')

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

  saveFile = ->
    if fileModel.editor?
      ws.emit 'save-file', fileModel.val()
      $('#save').removeClass('done')
      setTimeout -> $('#save').addClass('done')

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
    saveFile()

  $('#reload').click ->
    if fileModel.editor?
      reloadFile()

  window.addEventListener 'keydown', (event) ->
    if event.keyCode is 83 # 's'
      if event.ctrlKey or event.metaKey
        event.preventDefault()
        saveFile()