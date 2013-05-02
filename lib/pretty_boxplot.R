pretty_boxplot<-function(y,cols,labs=c("No Correction","Training Set Only","Training and Test Set")){

	boxplot(y,
			las=1,
			col=cols,
			outpch=20,
			outcex=0.5,
			lwd=2,
			medlwd=2,
			whisklty = "solid",
			xaxt='n',
			cex.axis=1.3)
		
	axis(side=1, at = c(1,2,3), 
		 labels=labs, lwd=2, cex.axis=1.3)
}