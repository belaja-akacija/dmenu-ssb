;;;; suckless search bar: search the web using dmenu

;;; TODO make a little config file to be able to set your browser and search engine from there, instead of having to recompile

(defparameter *search-engine* "https://duckduckgo.com/?kae=d&va=v&t=ha&q=")
;; To use the alt search engine, prefix your query with "alt: "
(defparameter *alt-search-engine* "https://searx.be/?preferences=eJxtV8tu7DYM_ZrOxsig7V0UXcyqQLct0Ls3aIljM5ZFRQ_POF9fyo-xHGcRJzqkKIqPQ0VBxJY9Ybi1aNGDuRiwbYIWb2BkwQoM3tBeIEVWPDiDEW8tc2vwQoPo1c7zc7r99AkvA8aO9e3ff_77eQlwx4DgVXf79RI7HPDGQYG_eAzJxFCzrS0-6gjN7W8wAS-aqRYhmxH9jUGWV_btZd71FuIkjhhuSbHG8U2D7y-BskP1IsseXhTaiL4GQ60d5O_VNOgRrEJdrx4t6EdCP9Vk60hRDMxXIHsnS1GMKs_GLKCmAI2R7WhbshKsP1to6zqwIjDVgJrgl9__AmshVNk-jVjXdzIYMuz6aiDv2ZeY-F3JtwqRfam87K4o1PWakRmNpOp6jvei9aRRzleEcisBGrJtuSGvq0W92DajI2lkQZffMxqbpHqMohllrZR6i2OhwA6tpCRgYUqCE4LHe-mEYA89kuS08GRCVy5V8oawRDTip2SsHlIgNa9HAhvlysVxWreVxjkzxPYQmwf1pCHCwabcJ_-0_D16Ds2SkAGcgPIVJEqip4Onvz2LDXftmfSeuLsh1ftSwSNWge_xAR4rTR6VpHpag3z3ZHuCMqmtFCE0WxKkyBv07bpcGq4KqmMDvgz6KnEGplxPYfeolAwseSmT3jrWugx7B42H_FlPJAuFei-Xg1AYNyTqfqpydAJ9I-B7pdi20s9lmA03IeLVh_UU-DSTJxV2P4RCQDmwq4J1w_bXBLAfk2vSo-PiZAfiY0thq2OXmqsU076SPi0j9_GQMivzOwPn0ljgU9sEdAQLnRzQDOTsVfnzyjYMkCOzAQEHMUrqu4yGXPsuM2vhW-R-4sih4z7HZrtzfFDMfPeVipINkvfQFdeYoONDO0ycYmqwcP6FvHoRyEwD554r1EYakIv1g5rpwFYGn2C1J_japw1zf2peGQKC5e8KfCSO-FUrcPLqhGZaojidYJ6-xE-Tip9sj_3848cfzz2WAT8tDKXCwO-IfYlYGHO0d8CnZmpx2OrZIfovQZ1TIvOvz8z4wKYQ-TTIVDlEsqdBSO5A5R7Gg9tOOsRshfctfK5hqb296ZZQdinu5PIydEF7nHSzPUM2Pavs3bqlkfwqGNxeKlno8lVPY-iQ3yZqats96DIPvNT9IYOaZRr5qksbGaIMlsy1LGH0RyJ_YI6t32UoSdsceWFRitjKJXDH5DhKBe_IOuY4LBGhuJ--8Gjp4Mqspyiv-OHCK3aij261upDtoJvdNbKiRZxK9QLbPH4nYYN91-fbSr0lF9t2PCRkoKcynHTBtyBzCDfWz7QKMqryQA0oj7SClzaZMKnMOlgH8VEeoky9KAN0m6JO52bYlVwnLGZfUvLyAG2g8NlNbiuyhXgP0RTPNMUT3UlFSz0eLyY0qnqWdr0bfmzjJvSpSTamrROSQ5_C6_ry9iQtU1pKMhaTZabO6itP5QDM4d4y8GCzEL3riuIbpkFqUiZi9GCDkfseKlmjLS14bakvgSf1bGWOVWGybMXWLgzv7uoe5fYY_ZU2YH-1OpOkmcMts8Pzuq6uDPXy4n54ee-us2sXBzR3eRvf-SSRANWqQ9W_yOL7A7o8gJbFyUbHIQrbohwvg0p9d_xMcFIravkfZZK3u5E31NkdD5kvanlZirUhp_ykIyOrlsrrcQoXGaVSqLf_AaCp6CU=&q=")
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
          ((cl-ppcre:scan "alt: " query)
        (setf query-full (concatenate 'string *alt-search-engine* (do-urlencode:urlencode (cl-ppcre:scan-to-strings "\(?<=alt:\\s\).\+" query))))
           (uiop:run-program `(,*browser* ,query-full)))
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
