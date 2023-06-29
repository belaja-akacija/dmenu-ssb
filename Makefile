LISP ?= sbcl
ASD := ssb.asd
ASD_PATH := $(shell pwd)/$(ASD)
BINARY := ssb
INSTALL_PATH := ~/.local/bin

load:
	rlwrap -c $(LISP) --eval "(asdf:load-asd #P\"$(ASD_PATH)\")" \
		--eval '(ql:quickload :$(BINARY))' \
		--eval '(if (cl-ppcre:all-matches "Vlime" (format nil "~A" (swank:list-threads))) 0 (vlime:main))'

build:
	$(LISP) --eval "(asdf:load-asd #P\"$(ASD_PATH)\")" \
		--eval '(ql:quickload :$(BINARY))' \
		--eval "(sb-ext:save-lisp-and-die #P\"$(BINARY)\" :toplevel #'main :executable t :compression t)" \
		--eval '(quit)'

install:
	install -v $(BINARY) $(INSTALL_PATH)/$(BINARY)

clean:
	rm -v $(BINARY)

uninstall:
	rm -v $(INSTALL_PATH)/$(BINARY)
