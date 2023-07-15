;;;; suckless search bar: search the web using dmenu

;;; TODO make a little config file to be able to set your browser and search engine from there, instead of having to recompile

(defparameter *search-engine* "https://duckduckgo.com/?kae=d&va=v&t=ha&q=")
(defparameter *browser* "firefox")
(defparameter *search-history* #P "~/.local/share/ssb/history") ; change this to where you want to save your history to
(defparameter *save-search?* nil) ; set to nil, if you don't want to save your history

(defun filter-search-query (query)
  (let ((filtered-str ""))
    (if (cl-ppcre:scan "http\(s\)*://" query)
        (setf filtered-str (cl-ppcre:scan-to-strings "\(?<=\\|\\s\).\+" query))
        (setf filtered-str query)) ; passthrough the untouched query, if it doesn't contain a link
    filtered-str))

(defun save-query (query)
  (let ((search-term (nth 0 query))
        (url (nth 1 query)))
    (append->file url search-term *search-history*)))

(defun ssb-search (query)
  (let ((query-full (concatenate 'string *search-engine* (do-urlencode:urlencode query))))
    (cond ((cl-ppcre:scan "http\(s\)*://" query)
           (uiop:run-program `(,*browser* ,query)))
          (t (if (equal *save-search?* t)
                 (save-query `(,query ,query-full))
                 nil)
             (uiop:run-program `(,*browser* ,query-full))))))

(defun ssb-get-query ()
  (if (null *save-search?*)
      (launch-dmenu-prompt (format nil "Search: "))
      (filter-search-query (launch-dmenu "6" *search-history* "Search: "))))

(defun main ()
  (ssb-search (ssb-get-query)))
