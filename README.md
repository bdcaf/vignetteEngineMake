# vignetteEngineMake

I started this package as I wanted to build more complex
vignette consisting of several sub files as well as data
that was reused, but not supposed to go into the repo or
into the package.  Also I would like the to use the
framework from R to manage package dependencies as weel as
loading scripts (`devtools::load_all`).

Personally I know how to achieve this with Makefiles.  There
are some projects around to implement these inside R,
currently I just don't see any advantage of these.

Unfortunately I currently have just  half knowledge  how the
build process works.  I will put more details of my research
at the bottom.

## how to use

1. create a Makefile in the vignettes directory (otherwise
   on cleanup _all_ files besides the vignettes will be
   removed.  Optionally this makefile may contain a clean
   target.  Note the default target will always be run, but
   _after_ the vignettes were produces,  so I put an empty
   default.
2. create a vignette make as in the example.  It is
   important that it includes the lines:
```
define VIGNETTE_OPTIONS
  %\VignetteEngine{vignetteEngineMake::make}
endef
```

The name of the definition is unimportant.  Additional
`%\Vignette` options may be placed in this region as
well.  Two targets are expected - both need to have the
same basename, but one with extension `.pdf` for weave
and one with `.R` for tangle.  For shared targets
`include` can be used.


## ToDos

- testing - the package is currently so simple that I'm not
    sure what to test for.
- checking input - I don't want to introduce limitations, so
    as long make doesn't complain I won't either.  There is
    a mess when a target or path contains spaces,  I'm not
    sure how to touch it.  Also escaping such that make, R and
    the shell are all happy is a sisiphean task which I want
    to avoid.

## background

### influences

#### R.rsp

I quickly was guided to the [R.rsp] package which has a
vignette builder for `asis` files directly copying them.  My
first intuition was to crate a branch inside this package,
after studying how it was achieved it seemed simpler to
just create a smaller focused package.

#### R source 

For convenience I searched the [R source mirror] on github.

I could only locate two R functions calling a Makefile.

There are only two examples in R code, both in the tools
package.  First in `build.R`  most code is about line
endings and correct spelling.  The only call to make is in
`cleanup_pkg` where src can be cleaned via `make clean`. 

The other file is [Vignettes.R] which has two interesting
calls.  One run for the default target on line 558, and
immediately after optionally clean on line 562.  However
this Makefile is only executed if other vignettes are in the
directory and copying stuff to `../inst/doc` needs to be
done manually.

### current best practices

I'm having some conversation on [stack overflow][sodiss].
The workflow is still confusing to me.  Most people put
Makefiles in their packages, but I still don't fully
understand whether these are to be executed automatically.
I suppose one could issue a `make all` before `R CMD build` - but I have never seen this.  I think it would be nice if `R CMD build` which is used to automatically install would do both.

[R.rsp]:https://cran.r-project.org/web/packages/R.rsp/index.html
[sodiss]: https://stackoverflow.com/questions/46741739/how-to-use-makefiles-with-r-cmd-build
[Vignettes.R]: https://github.com/wch/r-source/blob/trunk/src/library/tools/R/Vignettes.R
[R source mirror]: https://github.com/wch/r-source
