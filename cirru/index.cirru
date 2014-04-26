
doctype
html
  head
    title (= "Light Editor")
    meta (:charset utf-8)
    link (:rel stylesheet) (:href css/style.css)
    script (:defer) (:src build/build.js)
  body#app
    #files
    #detail
      #panel
        span.button#save (= Save)
        span.button#reload (= Reload)
        span#filename
      #wrap