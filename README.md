
Cirru Light Editor
------

This is an editor based on the module `cirru-editor`.

Basicly, it scans and saves file in `env.PWD`, and does:

* Editing code in GUI
* Load file from file system
* Save (with Command s) code via WebSocket
* Watch file system and reload file list

### Usage

The editor is not quite ready for daily use but you may try:

```bash
npm install -g cirru-light-editor
```

`cd` to a directory which contains `.cirru` files and run:

```
cirru-light-editor folder
cle folder # a short alias
```

Then you may visit http://repo.cirru.org/light-editor/
and found it connected to `localhost:7001` and you can try editing.

### Develop

This project is written in CirruScript.

### License

MIT