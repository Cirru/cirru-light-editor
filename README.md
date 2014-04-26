
Cirru Light Editor
------

This is an editor based on the module `cirru-editor`.

Basicly, it scans and saves file in `env.PWD`, and does:

* Editing code in GUI
* Load file from file system
* Save (with Command s) code via WebSocket
* Watch file system and reload file list

![](http://cirru.qiniudn.com/cirru-light-editor.png)

### Usage

The editor is not quite ready for daily use but you may try:

```bash
npm install -g cirru-light-editor
```

`cd` to a directory which contains `.cirru` files and run:

```
cirru-light-editor
```

Then you may visit http://repo.cirru.org/light-editor/
and found it connected to `localhost:7001` and you can try editing.

### Develop

By following these steps, you can develop the code:

* Setup Nginx (for Web page) and Node (for server)
* Clone code and run `npm install`
* Run `coffee make compile` to compile code
* Prepare a directory with `some.cirru` files
* Run `coffee src/serve.coffee` to listen at `7001`
* Visit generated `index.html` to connect to serve

And hopefully you would see it working.

### License

MIT