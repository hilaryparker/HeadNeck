Most of the packages are available on CRAN or bioconductor. One package is available on CRAN but is easier to install using the 'devtools' package:

	
If you need to install the packages, here are commands:

## Bioconductor
```{r}
source("http://bioconductor.org/biocLite.R")
biocLite("affy")
biocLite("frma")
biocLite("sva")
biocLite("matchBox")
biocLite("genefilter")
biocLite("hgu133plus2.db")
biocLite("limma")
biocLite("simpleaffy")
biocLite("geneplotter")
biocLite("hgu133plus2frmavecs")
```

## CRAN
```{r}
install.packages("ProjectTemplate")
install.packages("devtools")
install.packages("RColorBrewer")
install.packages("markdown")
install.packages("knitr")
install.packages("GSA")
```

## Devtools
```{r}
library(devtools)
install_github("broman","kbroman")

