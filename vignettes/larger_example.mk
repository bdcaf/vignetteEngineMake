# why
define VIGNETTE_OPTIONS
	%\VignetteIndexEntry{Acetone experiment warping}
	%\VignetteAuthor{Clemens Ager}
	%\VignetteKeyword{R}
	%\VignetteKeyword{package}
	%\VignetteKeyword{vignette}
	%\VignetteKeyword{example}
	%\VignetteKeyword{acetone}
	%\VignetteEngine{vignetteEngineMake::make}
	%\VignetteTangle{FALSE}
endef

THIS:=larger_example

$(THIS).pdf:
	cd $(THIS); make
	cd $(THIS); latexmk vignette.tex
	cp $(THIS)/vignette.pdf $@

$(THIS).R:
	touch $@
