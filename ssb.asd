(defsystem "ssb"
  :description "ssb: suckless searchbar for dmenu"
  :author "belaja-akacija"
  :depends-on ("cl-ppcre" "do-urlencode" "vlime")
  :components ((:file "utils")
               (:file "main" :depends-on ("utils")))
  :build-operation "program-op"
  :build-pathname "ssb"
  :entry-point "main")
