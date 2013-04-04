
qrsh -l mem_free=10G,h_vmem=12G

home<-"/home/bst/student/hiparker/HeadNeck"
setwd(home)
library("ProjectTemplate")
load.project()

# first things first -- organize code

# Use project Template



## visualize data before, pick batch based on this 

cols <- brewer.pal(8, "Reds")
cols<-rev(cols)

setwd("./graphs")

pdf(file="chung.pdf")
manyboxplot(frma.chung,dotcol=cols[1],linecol=cols[2:4],vlines=c(34.5,54.5),main="fRMA only")
manyboxplot(combat.frma.chung,dotcol=cols[1],linecol=cols[2:4],vlines=c(34.5,54.5),main="ComBat")
manyboxplot(sva.frma.chung,dotcol=cols[1],linecol=cols[2:4],vlines=c(34.5,54.5),main="SVA")
manyboxplot(sva.combat.frma.chung,dotcol=cols[1],linecol=cols[2:4],vlines=c(34.5,54.5),main="SVA + ComBat")
dev.off()

# code for batch correction

# ComBat first
# then go to SVA


# creating a predictor #

#divide into test, training sets

