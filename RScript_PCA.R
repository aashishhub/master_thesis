#!/usr/bin/env Rscript 
pdf("PCA_100kbp_wild_dom.pdf") 
args = commandArgs(trailingOnly=TRUE)
pca <- read.table(args[1], row.names=1)
pca
col.rainbow <- rainbow(7)
palette(col.rainbow)
family <- as.factor(pca[,22])
plot(pca$V3, pca$V4,,col=family, pch=19, cex=0.4, xlab="", ylab="")
legend("bottomright", col=unique(family), legend=unique(family), pch=19)
title(main="PCA 100kbp rs335979375", xlab="PC1", ylab="PC2")
text(pca$V3, pca$V4, rownames(pca), cex=0.2)  ## to add sample names  in points of plot
dev.off()
