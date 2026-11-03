# Sourced into ark kernels started by jet.ark once they're connected
# (see lua/plugins/jet.lua), after ark has set up its own options.

# jet.ark doesn't handle ark's html viewer requests, so use the browser
options(viewer = NULL)

# No image support in the terminal: send plots to httpgd in the browser
if (requireNamespace("httpgd", quietly = TRUE)) {
  options(device = function(...) {
    httpgd::hgd(..., silent = TRUE)
    httpgd::hgd_browse()
  })
}
