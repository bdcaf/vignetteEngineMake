#' @export
mweave <- function(file, ..., quiet=FALSE){
  if (!quiet) {
  cat(sprintf("weaving %s.\n", file))
  }
  outfile <- sub("[.]mk$", ".pdf", file)
  mr <- system2("make", args = paste("-f", file, outfile))
  if (mr > 0) stop(sprintf("making %s failed", outfile))
  invisible(outfile)
}
