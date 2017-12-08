#' @export
mtangle <-
  function(file, ..., quiet = F) {
  if (!quiet) {
  cat(sprintf("tangling %s.\n", file))
  }
  outfile <- sub("[.]mk$", ".R", file)
  mr <- system2("make", args = paste("-f", file, outfile))
  if (mr > 0) stop(sprintf("making %s failed", outfile))
}
