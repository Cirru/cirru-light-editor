
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
        span#filename
        span#save (= Save)
      #wrap