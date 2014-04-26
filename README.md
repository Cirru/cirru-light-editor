
Cirru Light Editor
------

This is a small editor for Cirru.

![](http://cirru.qiniudn.com/cirru-light-editor.png)

Start the server with `coffee src/serve.coffee`.

Load client in a static server and it would work.

Basicly, it scans and saves file in `env.PWD`, and does:

* Editing code in GUI
* Load file from file system
* Save code via WebSocket
* Watch file system and reload file list