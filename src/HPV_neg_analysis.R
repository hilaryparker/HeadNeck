setwd("/home/bst/student/hiparker/HeadNeck")
library("ProjectTemplate")
load.project()

## first computeCat - will get output list
## then plotCat - matrix with columns as t-stats

### HPV ANALYSIS ###

frmadat<-frma.chung
out<-info.chung$HPV.Stat

#################### NULL ANALYSIS ####################
# Differentially expressed genes #
null <- rowttests(frmadat,out)
# check the order of the statistics #
t.test(frmadat[1,out=="Neg"],frmadat[1,out=="Pos"])
# this is the correct order. so it's mean(Neg)-mean(Pos) #

# trying to get it set up for cat plots
nms <- rownames(null)
nullstats <- null$statistic
nulldat <- data.frame(idCol=nms,null=nullstats)


#################### COMBAT ONLY ####################
# Run ComBat #

# Differentially expressed genes #
combat<- rowttests(frmadat.combat,out)

# set up for cat plots #
nms <- rownames(combat)
combatstats <- combat$statistic
combatdat <- data.frame(idCol=nms,combat=combatstats)



#################### SVA AFTER COMBAT #################




## p16 analysis ##

# knew ahead of time symbol was CDKN2A (in literature) #
# wanted to get gene name to be sure #

x <- hgu133plus2SYMBOL
y <- hgu133plus2GENENAME
xx <- as.list(x)
yy <- as.list(y)

# match to known gene symbol #
temp <- grep("CDKN2A",xx)
yy[temp[1]]
# $`1554348_s_at`
# [1] "CDKN2A interacting protein N-terminal like"


yy[temp[2]]
# $`207039_at`
# [1] "cyclin-dependent kinase inhibitor 2A"
yy[temp[3]]
# $`209644_x_at`
# [1] "cyclin-dependent kinase inhibitor 2A"
yy[temp[4]]
# $`211156_at`
# [1] "cyclin-dependent kinase inhibitor 2A"
# probably measuring the end of hte gene
#alternative splicing
#bad hybridization
#falls off towards end of the gene
#RNA sequencing better than arrays


yy[temp[5]]
# $`218929_at`
# [1] "CDKN2A interacting protein"
yy[temp[6]]
# $`235006_at`
# [1] "CDKN2A interacting protein N-terminal like"

# 2, 3, 4 are the ones we want
temp[2]
# [1] 16486
temp[3]
# [1] 19054
temp[4]
# [1] 20520


# checking the change in differential expression for before/after

t.test(frmadat[temp[2],out=="Pos"],frmadat[temp[2],out=="Neg"])
# t = 7.7807
# mean of x mean of y
#  8.005600  5.171793

frmadat.combat<-combat.frma.chung

t.test(frmadat.combat[temp[2],out=="Pos"],frmadat.combat[temp[2],out=="Neg"])
# t = 8.5808
# mean of x mean of y
#  7.983374  5.174828

frmadat.combat.sva<-sva.combat.frma.chung

t.test(frmadat.combat.sva[temp[2],out=="Pos"],frmadat.combat.sva[temp[2],out=="Neg"])
# t = 10.0512
# mean of x mean of y
#  7.689968  5.316472


frmadat[temp[2],out=="Pos"]
pdf(file="temp.pdf",width=21)
par(mfrow=c(1,3))
boxplot(list(frmadat[temp[2],out=="Pos"],frmadat[temp[2],out=="Neg"]))
boxplot(list(frmadat.combat[temp[2],out=="Pos"],frmadat.combat[temp[2],out=="Neg"]))
boxplot(list(frmadat.combat.sva[temp[2],out=="Pos"],frmadat.combat.sva[temp[2],out=="Neg"]))
dev.off()

## boxplots of standard deviations - see what's going down in variance
## try to do a boxplot function if possible
## want to see HPV Pos going down in standard deviation
# sva only

# scientific first so that Christine can get 
# comfortable story before going to lab meeting

# correlate SV's with batch variables, see if they match up.
# both when done with ComBat and without--maybe it doesn't that's OK
# might correlate to more than one.

# don't spend too much time perfecting the boxplots

# does combat+sva make frozen + ffpe look more similar? That would be a really strong figure
# just worry about it in picture form for the time being

# combat just with amplification kit is fine.
# also do SVA alone and see how it performs.

#gene set statistics between positive and negative based on 



t.test(frmadat[temp[3],out=="Pos"],frmadat[temp[3],out=="Neg"])
# t = 6.0648
# mean of x mean of y
#  8.355814  6.611019

t.test(frmadat.combat[temp[3],out=="Pos"],frmadat.combat[temp[3],out=="Neg"])
# t = 7.0975
# mean of x mean of y
#  8.430110  6.577763

t.test(frmadat.combat.sva[temp[3],out=="Pos"],frmadat.combat.sva[temp[3],out=="Neg"])
# t = 7.8411
# mean of x mean of y
#  8.262802  6.658532


t.test(frmadat[temp[4],out=="Pos"],frmadat[temp[4],out=="Neg"])
# t = 1.4146 not significant
# mean of x mean of y
#  5.504952  4.976034

t.test(frmadat.combat[temp[4],out=="Pos"],frmadat.combat[temp[4],out=="Neg"])
# t = 1.2258 not significant
# mean of x mean of y
#  5.341518  5.105388

t.test(frmadat.combat.sva[temp[4],out=="Pos"],frmadat.combat.sva[temp[4],out=="Neg"])
# t = -0.3264 really not significant
# mean of x mean of y
#  5.158745  5.193623





datlist<-list(nulldat,combatdat)
dat<-mergeData(datlist,idCol=1,byCol=2)

# decreasing absolute

temp1<-computeCat(dat,idCol=1,method="equalRank",decreasing=TRUE)
temp2<-computeCat(data = dat, idCol = 1,
ref="dataSetA.t", method="equalRank", decreasing=TRUE)

temp<-computeCat(mat,method="equalRank",decreasing=TRUE)
temp2<-calcHypPI(frmadat[1:10000,])

pdf(file="temp.pdf")
plotCat(catData=temp,preComputedPI=temp2)
dev.off()

## where are normal samples ##


negdat<-frmadat[,info$HPV.Stat=="Neg"]

out<-as.numeric(info$Disease.state=="DOD")[info$HPV.Stat=="Neg"] #outcome is those that died of disease (DOD)

negdat<-negdat[,!is.na(out)]
out<-out[!is.na(out)]

