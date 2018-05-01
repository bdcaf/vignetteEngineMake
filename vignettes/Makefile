all: 

# trying ansers from https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile
# to check whether executable is available
LMK := $(shell command -v latexmk 2> /dev/null)
ifndef LMK
  $(error "latexmk is not available please install latexmk")
endif

%.pdf: latexmk-exists

.PHONY: latexmk-exists


# clean is run instead of removing EVERYTHING
clean: 

