;;;; suckless search bar: search the web using dmenu

;;; TODO make a little config file to be able to set your browser and search engine from there, instead of having to recompile

(defparameter *search-engine* "https://duckduckgo.com/?kae=d&va=v&t=ha&q=")
(defparameter *browser* "firefox")
(defparameter *search-history* #P "~/.local/share/ssb/history") ; change this to where you want to save your history to
(defparameter *save-search?* t) ; set to nil, if you don't want to save your history

(defun filter-search-query (query)
(let ((filtered-str ""))
  (if (cl-ppcre:scan "https://" query)
      (setf filtered-str (cl-ppcre:scan-to-strings "\(?<=\\|\\s\).\+" query))
      (setf filtered-str query))
  filtered-str))

(defun save-query (query)
  (let ((search-term (nth 0 query))
        (url (nth 1 query)))
    (append->file url search-term *search-history*)))

(defun ssb-search (query)
  (let ((query-full (concatenate 'string *search-engine* (do-urlencode:urlencode query))))
    (if (cl-ppcre:scan "https://" query)
        (uiop:run-program `(,*browser* ,query))
        (uiop:run-program `(,*browser* ,query-full)))
    (if (equal *save-search?* t)
        (save-query `(,query ,query-full))
        nil)))

(defun ssb-get-query ()
  (if (null *save-search?*)
      (launch-dmenu-prompt (format nil "Search: "))
      (filter-search-query (launch-dmenu "6" *search-history* "Search: "))))

(defun main ()
  (ssb-search (ssb-get-query)))