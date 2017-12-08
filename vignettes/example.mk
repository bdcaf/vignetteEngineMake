define VIGNETTE_OPTIONS
  %\VignetteEngine{vignetteEngineMake::make}
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

