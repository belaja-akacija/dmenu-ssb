(defmacro handle-error (condition)
  `(multiple-value-bind (value y error) ,condition
     (if (= error 1)
         (uiop:quit 0)
         (string-trim '(#\NewLine #\Space) value))))

(defun launch-dmenu (lngth file &optional label)
  (handle-error
    (uiop:run-program `("dmenu" "-l" ,lngth "-p" ,label)
                      :input file
                      :output :string
                      :ignore-error-status t)))

(defun launch-dmenu-prompt (prompt)
  (handle-error
    (uiop:run-program `("dmenu" "-l" "6" "-p" ,prompt) :output :string :ignore-error-status t)))

(defun append->file (url desc path)
  (with-open-file (output path :direction :output
                          :if-exists :append :if-does-not-exist :create)
    (format output "~A | ~A~%" desc url )))
