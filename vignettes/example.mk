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

example.pdf:
	cd exampledata; latexmk example.tex
	cp exampledata/example.pdf $@
