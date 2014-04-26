
Cirru Light Editor
------

This is an editor based on the module `cirru-editor`.

Basicly, it scans and saves file in `env.PWD`, and does:

* Editing code in GUI
* Load file from file system
* Save code via WebSocket
* Watch file system and reload file list

![](http://cirru.qiniudn.com/cirru-light-editor.png)

### Usage

This editor is currently only running in my laptop.
If you want to try it, there are steps to follow:

* Setup Nginx (for Web page) and Node (for server)
* Clone code and run `npm install`
* Run `coffee make compile` to compile code
* Prepare a directory with `some.cirru` files
* Run `coffee src/serve.coffee` to listen at `7001`
* Visit generated `index.html` to connect to serve

And hopefully you would see it working.

### License

MIT