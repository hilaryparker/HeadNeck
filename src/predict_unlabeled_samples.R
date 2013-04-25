
setwd("/home/bst/student/hiparker/HeadNeck")
library("ProjectTemplate")
load.project()

# run sva on the database (will be used later in fsva) #
mod<-model.matrix(~as.factor(info.chung$HPV.Stat))
sva.frma<-sva(frma.chung,mod)
sva.combat.frma<-sva(combat.frma.chung,mod)

fsva.sva.frma <- fsva(dbdat=frma.chung, mod=mod, sv=sva.frma, newdat=frma.chung.naHPV, method="exact")	
fsva.sva.combat.frma <- fsva(dbdat=combat.frma.chung, mod=mod, sv=sva.combat.frma, newdat=frma.chung.naHPV, method="exact")	

# no batch correction
fit <- pamr.train(list(x=frma.chung,y=as.factor(info.chung$HPV.Stat)))
pred.none <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# combat on database only
fit <- pamr.train(list(x=combat.frma.chung,y=as.factor(info.chung$HPV.Stat)))
pred.combat <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# combat + fsva correction
fit <- pamr.train(list(x=combat.frma.chung,y=as.factor(info.chung$HPV.Stat)))
pred.combat.fsva <- pamr.predict(fit,fsva.sva.frma$new,threshold=2)

# sva on database only
fit <- pamr.train(list(x=fsva.sva.frma$db,y=as.factor(info.chung$HPV.Stat)))
pred.sva <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# sva + fsva correction
fit <- pamr.train(list(x=fsva.sva.frma$db,y=as.factor(info.chung$HPV.Stat)))
pred.sva.fsva <- pamr.predict(fit,fsva.sva.frma$new,threshold=2)

# sva + combat on database only
fit <- pamr.train(list(x=fsva.sva.combat.frma$db,y=as.factor(info.chung$HPV.Stat)))
pred.sva.combat <- pamr.predict(fit,frma.chung.naHPV,threshold=2)

# sva + combat + fsva correction
fit <- pamr.train(list(x=fsva.sva.combat.frma$db,y=as.factor(info.chung$HPV.Stat)))
pred.sva.combat.fsva <- pamr.predict(fit,fsva.sva.combat.frma$new,threshold=2)


predictions_nofSVA<-cbind(as.character(pred.none), as.character(pred.combat), as.character(pred.sva),as.character(pred.sva.combat))
rownames(predictions_nofSVA)<-info.chung.naHPV$Affy.Microarray
colnames(predictions_nofSVA)<-c("None","ComBat","SVA","ComBat+SVA")

predictions_fSVA<-cbind(as.character(pred.none), as.character(pred.combat.fsva), as.character(pred.sva.fsva),as.character(pred.sva.combat.fsva))
rownames(predictions_fSVA)<-info.chung.naHPV$Affy.Microarray
colnames(predictions_fSVA)<-c("None","ComBat+fSVA","SVA+fSVA","ComBat+SVA+fSVA")

ProjectTemplate::cache("predictions_nofSVA")
ProjectTemplate::cache("predictions_fSVA")

# in markdown document, write 
# print(xtable(predictions), type='html')



## look at boxplots after fSVA correction, before fSVA correction
setwd("C:/Users/Hilary/GitHub/HeadNeck/graphs")

png(file="uncorrectednewsamps1.png")
manyboxplot(cbind(frma.chung,frma.chung.naHPV),dotcol=cols[1],linecol=cols[2:4],vlines=86.5,main="Uncorrected database, uncorrected samples")
dev.off()


png(file="uncorrectednewsamps2.png")
manyboxplot(cbind(sva.frma.chung,frma.chung.naHPV),dotcol=cols[1],linecol=cols[2:4],vlines=86.5,main="SVA corrected database, uncorrected samples")
dev.off()

manyboxplot(cbind(sva.frma.chung,fsva.sva.frma$new),dotcol=cols[1],linecol=cols[2:4],vlines=86.5,main="SVA corrected database, fSVA corrected samples")


png(file="correctednewsamps.png")
manyboxplot(cbind(sva.combat.frma.chung,fsva.sva.combat.frma$new),dotcol=cols[1],linecol=cols[2:4],vlines=86.5,main="SVA + ComBat corrected database, fSVA corrected samples")
dev.off()
