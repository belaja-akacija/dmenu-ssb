(defun launch-dmenu (lngth file &optional label)
  (string-trim '(#\NewLine #\Space) (uiop:run-program `("dmenu" "-l" ,lngth "-p" ,label)
                     :input file
                     :output :string
                     :ignore-error-status nil)))

(defun launch-dmenu-prompt (prompt)
  (string-trim '(#\NewLine) (uiop:run-program `("dmenu" "-l" "6" "-p" ,prompt) :output :string :ignore-error-status nil)))

(defun append->file (url desc path)
  (with-open-file (output path :direction :output
                          :if-exists :append :if-does-not-exist :create)
    (format output "~A | ~A~%" desc url )))
