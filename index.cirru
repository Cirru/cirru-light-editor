doctype

html
  head
    title "Light Editor"
    meta (:charset utf-8)
    link (:rel icon) (:type image/png)
      :href http://logo.cirru.org/cirru-32x32.png?v=3
    link (:rel stylesheet) (:href style/layout.css)
    script (:defer)
      :src (@ main)
  body
