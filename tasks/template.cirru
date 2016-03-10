
var
  fs $ require :fs
  stir $ require :stir-template
  path $ require :path
  settings $ require :./settings
  resource $ require :./resource
  ({}~ html head title meta link script body div style) stir

  logoUrl :http://logo.cirru.org/cirru-32x32.png

  mixpanelHTML $ fs.readFileSync (path.join __dirname :mixpanel.html) :utf8

= module.exports $ \ (env)
  var
    config $ settings.get env
    assets $ resource.get config

  stir.render
    stir.doctype
    html null
      head null
        title null ":Light Editor"
        meta $ {} :charset :utf-8
        , mixpanelHTML
        link $ {} :rel :icon :href logoUrl
        cond (? assets.style)
          link $ {} :rel :stylesheet :href assets.style
        script $ {} :src assets.vendor :defer true
        script $ {} :src assets.main :defer true
        style null ":body * {box-sizing: border-box;}"
      body ({} :style ":margin: 0;")
        div ({} :id :app)
