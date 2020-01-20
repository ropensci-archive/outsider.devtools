# prevent spinner
original_func <- getFromNamespace(x = 'r', ns = 'callr')
rfunc <- function(func, args, show, ...) {
  original_func(func = func, args = args, show = FALSE, ...)
}
assignInNamespace(x = 'r', value = rfunc, ns = 'callr')

# precompile
library(knitr)
vgnts <- c('basic.Rmd', 'intermediate.Rmd', 'advanced.Rmd')
for (vgnt in vgnts) {
  knit(paste0("vignettes/", vgnt, ".orig"), paste0("vignettes/", vgnt))
}

library(devtools)
build_vignettes()