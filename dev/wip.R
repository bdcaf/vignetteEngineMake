wip <- function (package, dir, lib.loc = NULL, quiet = TRUE, clean = TRUE,
    tangle = FALSE) {
    vigns <- pkgVignettes(package = package, dir = dir, lib.loc = lib.loc,
        check = TRUE)
    if (is.null(vigns))
        return(invisible())
    if (length(vigns$msg))
        warning(paste(vigns$msg, collapse = "\n"), domain = NA)
    dups <- duplicated(vigns$names)
    if (any(dups)) {
        names <- unique(vigns$names[dups])
        docs <- sort(basename(vigns$docs[vigns$names %in% names]))
        stop(gettextf("Detected vignette source files (%s) with shared names (%s) and therefore risking overwriting each others output files",
            paste(sQuote(docs), collapse = ", "), paste(sQuote(names),
                collapse = ", ")), domain = NA)
    }
    Sys.unsetenv("SWEAVE_STYLEPATH_DEFAULT")
    op <- options(warn = 1)
    wd <- getwd()
    if (is.null(wd))
        stop("current working directory cannot be ascertained")
    on.exit({
        setwd(wd)
        options(op)
    })
    setwd(vigns$dir)
    origfiles <- list.files(all.files = TRUE)
    have.makefile <- "Makefile" %in% origfiles
    WINDOWS <- .Platform$OS.type == "windows"
    file.create(".build.timestamp")
    loadVignetteBuilder(vigns$pkgdir)
    outputs <- NULL
    sourceList <- list()
    startdir <- getwd()
    for (i in seq_along(vigns$docs)) {
        file <- basename(vigns$docs[i])
        name <- vigns$names[i]
        engine <- vignetteEngine(vigns$engines[i])
        enc <- vigns$encodings[i]
        if (enc == "non-ASCII")
            stop(gettextf("Vignette '%s' is non-ASCII but has no declared encoding",
                file), domain = NA, call. = FALSE)
        output <- tryCatch({
            engine$weave(file, quiet = quiet, encoding = enc)
            setwd(startdir)
            find_vignette_product(name, by = "weave", engine = engine)
        }, error = function(e) {
            stop(gettextf("processing vignette '%s' failed with diagnostics:\n%s",
                file, conditionMessage(e)), domain = NA, call. = FALSE)
        })
        if (!have.makefile && vignette_is_tex(output)) {
            texi2pdf(file = output, clean = FALSE, quiet = quiet)
            output <- find_vignette_product(name, by = "texi2pdf",
                engine = engine)
        }
        outputs <- c(outputs, output)
        if (tangle) {
            output <- tryCatch({
                engine$tangle(file, quiet = quiet, encoding = enc)
                setwd(startdir)
                find_vignette_product(name, by = "tangle", main = FALSE,
                  engine = engine)
            }, error = function(e) {
                stop(gettextf("tangling vignette '%s' failed with diagnostics:\n%s",
                  file, conditionMessage(e)), domain = NA, call. = FALSE)
            })
            sourceList[[file]] <- output
        }
    }
    if (have.makefile) {
        if (WINDOWS) {
            rhome <- chartr("\\", "/", R.home())
            Sys.setenv(R_HOME = rhome)
        }
        make <- Sys.getenv("MAKE", "make")
        if (!nzchar(make))
            make <- "make"
        yy <- system(make)
        if (yy > 0)
            stop("running 'make' failed")
        if (clean && any(startsWith(readLines("Makefile", warn = FALSE),
            "clean:")))
            system(paste(make, "clean"))
    }
    else {
        grDevices::graphics.off()
        keep <- c(outputs, unlist(sourceList))
        if (clean) {
            f <- setdiff(list.files(all.files = TRUE, no.. = TRUE),
                keep)
            newer <- file_test("-nt", f, ".build.timestamp")
            unlink(f[newer], recursive = TRUE)
            f <- setdiff(list.files(all.files = TRUE, no.. = TRUE),
                c(keep, origfiles))
            f <- f[file_test("-f", f)]
            file.remove(f)
        }
    }
    stopifnot(length(outputs) == length(vigns$docs))
    vigns$outputs <- outputs
    vigns$sources <- sourceList
    if (file.exists(".build.timestamp"))
        file.remove(".build.timestamp")
    invisible(vigns)
}
