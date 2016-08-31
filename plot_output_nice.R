#!/usr/bin/Rscript
args <-commandArgs(TRUE)

#Example with BMI - just change the pheno and it should work - remember to be in the right dir!
pheno=args[1]
setwd(paste(pheno,'/output/',sep=''))

monsterFile <- grep(paste(pheno,'*_monster.out',sep=''),dir())
monster <- read.table(monsterFile),h=T,as.is=T)
#monster <- read.table(paste(pheno,'.extra_monster.out',sep=''),h=T,as.is=T)
for(gene in monster$SNP_set_ID){
  tryCatch({
    assoc <- read.table(dir()[dir() %in% paste(gene,'.assoc',sep='')],h=T,as.is=T)
  }, error = function(e){ 
    print('No single point SNPs associations found for')
    print(gene)
    print('skipping gene')
    print('-------------')
  })
  if(dim(assoc)[1]>0){
    genebed <- read.table(paste('../',gene,'_GRCh37.bed',sep=''),h=F,as.is=T)
    colnames(genebed) <- c('chr','startpos','endpos','name')
    
  assoc$log10P <- -log10(assoc$p_lrt)
  assoc$type <- rep('rare',nrow(assoc))
  assoc[assoc$af>=0.05,'type'] <- 'common'
  #All
  png(paste(gene,pheno,'png',sep='.'),width=1000,height=800)
  plot(assoc$ps,assoc$log10P,pch=19,xlab=paste('chr',(assoc$chr)[1],':pos'),ylab='-log10(P)',
       col=ifelse(assoc$type=='rare','red','black'),
       main=paste(gene,', P(monster)=',monster[monster$SNP_set_ID==gene,'p_MONSTER'],sep=''))
    points(assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),'ps'],assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),'log10P'],cex=1.5,col='blue',lwd=2)
  legend('topleft',legend=c('rare','common','SNPs used by MONSTER'),col=c('red','black','blue'),pch=c(19,19,1),pt.lwd=c(1,1,2))
  dev.off()

    
    write.table(assoc[assoc$ps %in% c(genebed$startpos,genebed$endpos),],paste('SPA_variants_used_by_MONSTER_for',gene,'assoc_to',pheno,sep='_'),row.names=F,quote=F)


    
    if(FALSE){
      #Plots rare and common on their own plots (might not be relevant)
  rare <- assoc[assoc$af<0.05,]
  common <- assoc[assoc$af>=0.05,]

    
  #Common
  png(paste(gene,pheno,'common','extra','png',sep='.'),width=1000,height=800)
  plot(common$ps,common$log10P,pch=19,xlab=paste('chr',(assoc$chr)[1],':pos'),ylab='-log10(P)',
        main=paste('Common in ',gene,', P(monster)=',monster[monster$SNP_set_ID==gene,'p_MONSTER'],sep=''))
  dev.off()

  #Rare
  png(paste(gene,pheno,'rare','extra','png',sep='.'),width=1000,height=800)
  plot(rare$ps,rare$log10P,pch=19,xlab=paste('chr',(assoc$chr)[1],':pos'),ylab='-log10(P)',
       main=paste('Rare in ',gene,', P(monster)=',monster[monster$SNP_set_ID==gene,'p_MONSTER'],sep=''))
  dev.off()
}
}else{
    cat(paste('No single point SNPs associations found for:\n',gene,'\nskipping gene\n-------------\n',sep=''))
}}

  
