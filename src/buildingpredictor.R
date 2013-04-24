
setwd("/home/bst/student/hiparker/HeadNeck")
library("ProjectTemplate")
load.project()

## put things into easier names
dat <- combat.frma.chung
out <- as.factor(info.chung$HPV.Stat)

# total number of samples
n <- dim(dat)[2]


## to be reproducible, always set the seed. 
## The ensures that you pull the same "random" set next time.
set.seed(12345)

# number of iterations, i.e. number of times I'll create training and testing sets.
n.it<-2

# number of samples in training and testing sets (half of total sample size)
simsize<-43

# creating vectors for storing accuracy results
fast.out<-rep(0,n.it)
dbonly.out<-rep(0,n.it)
dbfsva.out<-rep(0,n.it)

# create a vector that will be used to create the training, testing sets. 
# (2's are created in case there are some samples that will be left out)
tmp<-c(rep(2,n-2*simsize),rep(0,simsize),rep(1,simsize))

for(s in 1:n.it){
	print(s)
	# create random database vs. new samples index #
	ind<-sample(tmp,n,replace=FALSE)

	# sort into lists for later use #
	db.dat<-dat[,ind==0]
	db.out<-out[ind==0]
	newsamp.dat<-dat[,ind==1]
	newsamp.out<-out[ind==1]

	# run sva on the database (will be used later in fsva) #
	mod<-model.matrix(~as.factor(db.out))
	db.sva<-sva(db.dat,mod)

	fsva.res <- fsva(dbdat=db.dat, mod=mod, sv=db.sva, newdat=newsamp.dat, method="exact")	
	fast.fsva.res <- fsva(dbdat=db.dat, mod=mod, sv=db.sva, newdat=newsamp.dat, 
							 method="fast")

	# uncorrected #

	none.out[s] <- predictor_PAM(train.dat=db.dat, train.grp=db.out,
				   test.dat=newsamp.dat, test.grp=newsamp.out)

	dbonly.out[s] <- predictor_PAM(train.dat=fsva.res$db, train.grp=db.out,
					test.dat=newsamp.dat, test.grp=newsamp.out)

	dbfsva.out[s] <- predictor_PAM(train.dat=fast.fsva.res$db, train.grp=db.out,
				   test.dat=fast.fsva.res$new, test.grp=newsamp.out)
}

predictor_results<-list(none.out=none.out,dbonly.out=dbonly.out,dbfsva.out=dbfsva.out,
				  simsize=simsize,n.it=n.it)
ProjectTemplate::cache("predictor_results")
