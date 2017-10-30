#' @importFrom tools vignetteEngine
register_vignette_engine <- function(pkg) {
  vignetteEngine(name = "make",
                 weave = mweave,
                 tangle = mtangle,
                 pattern = "[.]mk$",
                 package = "vignetteEngineMake"
                 )
}
