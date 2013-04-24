
setwd("/home/bst/student/hiparker/HeadNeck")
library("ProjectTemplate")
load.project()

# combat.frma.chung
fit <- pamr.train(list(x=combat.frma.chung,y= info.chung$HPV.Stat))
pred.combat <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# sva.frma.chung
fit <- pamr.train(list(x=sva.frma.chung,y= info.chung$HPV.Stat))
pred.sva <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# sva.combat.frma.chung
fit <- pamr.train(list(x=sva.combat.frma.chung,y= info.chung$HPV.Stat))
pred.sva.combat <- pamr.predict(fit,frma.chung.naHPV,threshold=2)


# given both the improvement in the prediction accuracy using SVA, as well as
# the improvement in the boxplots, I am going with sva results.

predictions<-cbind(as.character(pred.combat), as.character(pred.sva), as.character(pred.sva.combat))
rownames(predictions)<-info.chung.naHPV$Affy.Microarray
colnames(predictions)<-c("ComBat","SVA","SVA and ComBat")

ProjectTemplate::cache("predictions")

# in markdown document, write 
# print(xtable(predictions), type='html')

