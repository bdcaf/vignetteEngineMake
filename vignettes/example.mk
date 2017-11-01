# why
define VIGNETTE_OPTIONS
  %\VignetteAuthor{Clemens Ager}
  %\VignetteKeyword{R}
  %\VignetteKeyword{package}
  %\VignetteKeyword{vignette}
  %\VignetteKeyword{Example}
  %\VignetteEngine{vignetteEngineMake::make}
  %\VignetteTangle{FALSE}
endef

WORKDIR:=exampledata

example.pdf: $(WORKDIR)/example.tex $(WORKDIR)/test1.tex
	cd $(WORKDIR); latexmk example.tex
	cp $(WORKDIR)/example.pdf $@

%.R: 
	touch $@

$(WORKDIR)/test%.tex:
	echo This is > $@
	echo $@ >> $@
