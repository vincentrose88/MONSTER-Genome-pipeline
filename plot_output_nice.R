#!/usr/bin/Rscript
args <-commandArgs(TRUE)

pheno=args[1]
gene=args[2]
outputSuffix=args[3]
setwd(paste(pheno,gene,outputSuffix,'output/',sep='/'))

monsterFile <- dir()[grep(paste(pheno,outputSuffix,'*.monster.out',sep='.'),dir())]
monster <- read.table(monsterFile,h=T,as.is=T)

tryCatch({
  assoc <- read.table(dir()[dir() %in% paste(gene,'.assoc',sep='')],h=T,as.is=T)
  genebed <- read.table(paste('../',gene,'_GRCh37.bed',sep=''),h=F,as.is=T)
  colnames(genebed) <- c('chr','startpos','endpos','name')
  
  assoc$log10P <- -log10(assoc$p_lrt)
  assoc$type <- rep('rare',nrow(assoc))
  assoc[assoc$af>=0.05,'type'] <- 'common'
  
  png(paste('plots',paste(gene,pheno,outputSuffix,'png',sep='.'),sep='/'),width=1000,height=800)
  plot(assoc$ps,assoc$log10P,pch=19,xlab=paste('chr',(assoc$chr)[1],':pos'),ylab='-log10(P)',
       col=ifelse(assoc$type=='rare','red','black'),
       main=paste(gene,', P(monster)=',monster[monster$SNP_set_ID==gene,'p_MONSTER'],sep=''))
  points(assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),'ps'],assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),'log10P'],cex=1.5,col='blue',lwd=2)
  legend('topleft',legend=c('rare','common','SNPs used by MONSTER'),col=c('red','black','blue'),pch=c(19,19,1),pt.lwd=c(1,1,2))
  dev.off()
    
    
  write.table(assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),],paste('SPA_variants_used_by_MONSTER_for',gene,'assoc_to',pheno,outputSuffix,sep='_'),row.names=F,quote=F)
  
},error = function(e){ 
  print('No single point SNPs associations found for')
  print(gene)
  print('skipping gene')
  print('-------------')
})


  
