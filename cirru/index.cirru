
doctype
html
  head
    title (= "Light Editor")
    meta (:charset utf-8)
    link (:rel stylesheet) (:href css/style.css)
    script (:defer) (:src build/build.js)
    link (:rel icon) (:type image/png)
      :href http://logo.cirru.org/cirru-32x32.png?v=3"
  body#app
    #sidebar
      input#filter
      #files
    #detail
      #panel
        span.button#save (= Save)
        span.button#reload (= Reload)
      #wrap