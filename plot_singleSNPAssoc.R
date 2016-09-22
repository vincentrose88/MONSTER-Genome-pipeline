#!/usr/bin/Rscript
args <-commandArgs(TRUE)

pheno=args[1]
gene=args[2]
outputSuffix=args[3]
print(args)

setwd(paste(pheno,gene,outputSuffix,'output/',sep='/'))

monsterFile <- dir()[grep(paste(pheno,gene,'monster.out',sep='.'),dir())]
monster <- read.table(monsterFile,h=T,as.is=T)

tryCatch({
  assoc <- read.table(dir()[dir() %in% paste(gene,'.assoc',sep='')],h=T,as.is=T)
  SNPinfo <- read.table(paste('../',pheno,'.',gene,'_SNP_info',sep=''),h=T,as.is=T)
  positions <- t(sapply(SNPinfo$variant,function(x) {y <- strsplit(x,'_'); return(y[[1]])}))
 
  genebed <- data.frame(chr=as.integer(substring(positions[,1],4,nchar(positions[,1]))),
                        pos=as.integer(positions[,2]),
                        name=SNPinfo$rsID)

  
  assoc$log10P <- -log10(assoc$p_lrt)
  assoc$type <- rep('rare',nrow(assoc))
  assoc[assoc$af>=0.05,'type'] <- 'common'
  
  png(paste('plots',paste(gene,pheno,outputSuffix,'png',sep='.'),sep='/'),width=1000,height=800)
  plot(assoc$ps,assoc$log10P,pch=19,xlab=paste('chr',(assoc$chr)[1],':pos'),ylab='-log10(P)',
       col=ifelse(assoc$type=='rare','red','black'),
       main=paste(gene,', P(monster)=',monster[monster$SNP_set_ID==gene,'p_MONSTER'],sep=''))
  points(assoc[assoc$rs %in% genebed$name,'ps'],assoc[assoc$rs %in% genebed$name,'log10P'],cex=1.5,col='blue',lwd=2)
  legend('topleft',legend=c('rare','common','SNPs used by MONSTER (via rsID)'),col=c('red','black','blue'),pch=c(19,19,1),pt.lwd=c(1,1,2))
  dev.off()
    
    
  #write.table(assoc[assoc$ps %in% genebed$pos,],paste('SPA_variants_used_by_MONSTER_for',gene,'assoc_to',pheno,outputSuffix,sep='_'),row.names=F,quote=F)
  
},error = function(e){ 
  print('No single point SNPs associations found for')
  print(gene)
  print('skipping gene')
  print('-------------')
})


  
