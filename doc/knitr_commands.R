setwd("C:/Users/Hilary/GitHub/HeadNeck/doc")
library(knitr)
opts_knit$set(root.dir="C:/Users/Hilary/GitHub/HeadNeck",base.dir="C:/Users/Hilary/GitHub/HeadNeck/doc")
knit("statworkflow.Rmd")


setwd("/home/bst/student/hiparker/fSVA/doc")
library(knitr)
opts_knit$set(root.dir="/home/bst/student/hiparker/fSVA",base.dir="/home/bst/student/hiparker/fSVA/doc")
knit("fsva-Bioinformatics.Rnw")