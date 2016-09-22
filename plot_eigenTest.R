#!/usr/bin/Rscript

t <- read.table('eigenTestWideMinShift.par.results.merged',as.is=T,h=T)
u <- read.table('results.from.UK10K',h=T,as.is=T)


# Adding catagories 
t$MAF <- 0.5
t$floor <- 0.1
t$EigenShift <- 1
#Special case
u$MAF <- 0.01
u$floor <- NA
u$EigenShift <- NA
u$catagory <- 8

t[grep('MAF0.01',t$TestName),'MAF'] <- 0.01
t[grep('Floor0.000001',t$TestName),'floor'] <- 0.000001
t[grep('EigenShift.3',t$TestName),'EigenShift'] <- 4.15

# Numerical catagory
t$catagory <- 2*2*(t$MAF*100)%%5 + 2*as.integer(t$EigenShift==4.15) + (t$floor*1e6)%%1e5

#Overview
catagories <- data.frame(catagory=t[t$Gene=='APOA5','catagory'],
                         MAF=t[t$Gene=='APOA5','MAF'],
                         EigenShift=t[t$Gene=='APOA5','EigenShift'],
                         Floor=t[t$Gene=='APOA5','floor'])
catagories <- rbind(catagories,data.frame(catagory=8,
                            MAF=0.01,
                            EigenShift='NA',
                            Floor='NA'))

catagories <- catagories[order(catagories$catagory),]

#for plotting
legend.all.catagories <- paste(catagories$catagory,': MAF=',catagories$MAF,', Shift=',catagories$EigenShift,', Floor=',catagories$Floor,sep='')

lowMAF.catagories <- catagories[catagories$MAF==0.01,]
legend.lowMAF.catagories <- paste(lowMAF.catagories$catagory,': MAF=',lowMAF.catagories$MAF,', Shift=',lowMAF.catagories$EigenShift,', Floor=',lowMAF.catagories$Floor,sep='')

highMAF.catagories <- catagories[catagories$MAF==0.5 | catagories$catagory==8,]
legend.highMAF.catagories <- paste(highMAF.catagories$catagory,': MAF=',highMAF.catagories$MAF,', Shift=',highMAF.catagories$EigenShift,', Floor=',highMAF.catagories$Floor,sep='')

#Modified from imputation plotter
plotNice <- function(x,logP=FALSE,Ncat=9,legend.key=NULL,placement='topright',...){
  sigT <- x
  ylabel='P'
  if(logP){
    sigT$P <- -log10(sigT$P)
    ylabel='-log10(P)'
  }
  #8 catagories
  sigT$GeneN <- sort(rep(rep(1:(dim(sigT)[1]/Ncat)),Ncat))

  linetype <- c(1:(dim(sigT)[1]/Ncat))%%6 + 1
  colors <- rainbow(dim(sigT)[1]/Ncat)

  plot(sigT$catagory,sigT$P,type='n',xlab='Catagory',ylab=ylabel,...)
    
  for(i in 1:max(sigT$GeneN)){
    tmpT <- subset(sigT,GeneN==i)
    tmpT <- tmpT[order(tmpT$catagory),]
    lines(tmpT$catagory,tmpT$P,type='b',col=colors[i],lty=linetype[i])
  }
  if(!is.null(legend.key)){
    legend(placement,legend=legend.key)
  }
  
}

final <- rbind(t,u)
t <- final[order(final$Gene),]

png('all_eigenTests.png',width=800)
plotNice(t,main='all catagories',legend.key=legend.all.catagories)
dev.off()


png('lowMAF_eigenTests.png',width=800)
plotNice(t[t$MAF==0.01,],main='Few variants (MAF <= 0.01)',legend.key=legend.lowMAF.catagories,Ncat=5,placement='topleft')
dev.off()


png('highMAF_eigenTests.png',width=800)
plotNice(t[t$MAF==0.5 | t$catagory==8,],main='Many Variants (no MAF filter)',legend.key=legend.highMAF.catagories,Ncat=5)
dev.off()


