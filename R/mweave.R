#' @export
mweave <- function(file, ..., quiet=FALSE){
  if (!quiet) {
  cat(sprintf("weaving %s.\n", file))
  }
  system2("make", args = paste("-f", file))
}
