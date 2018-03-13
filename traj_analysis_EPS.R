#! /usr/bin/env Rscript

#################################################
#################################################
##########  traj_analysis_EPS.R   ###############
#########  AUTHOR: Kyle M. Stiers ###############
#################################################
#################################################

args = commandArgs(trailingOnly=TRUE)
#if(length(args)==0){ #optional error-checking
#    stop("At least 3 arguments must be supplied.n",call.=FALSE)
#}

setwd(args[1])
setEPS()
require("bio3d")

pdb <- read.pdb(args[2])
dcd <- read.dcd(args[3])

ca.inds <- atom.select(pdb, elety="CA")

xyz <- fit.xyz(fixed=pdb$xyz, mobile=dcd,fixed.inds=ca.inds$xyz,mobile.inds=ca.inds$xyz)

## RMSD plotting (standard viz)
rd <- rmsd(xyz[1,ca.inds$xyz], xyz[,ca.inds$xyz])
postscript("rmsd.eps")
plot(rd, typ="l", ylab="RMSD", xlab="Frame No.")
points(lowess(rd), typ="l", col="red", lty=2, lwd=2)
dev.off()

## RMSD Histogram
postscript("rmsd_density.eps")
hist(rd, breaks=40, freq=FALSE, main="RMSD Histogram", xlab="RMSD")
lines(density(rd), col="blue", lwd=3)
dev.off()
#summary(rd)

## RMSF
rf <- rmsf(xyz[,ca.inds$xyz])
postscript("rmsf.eps")
plot(rf, ylab="RMSF", xlab="Residue Position", typ="l")
dev.off()
#pymol(pdb, col=rf) #this should work according to documentation but causes a crash #TODO

## PCA
pc <- pca.xyz(xyz[,ca.inds$xyz])
postscript("pca.eps")
plot(pc, col=bwr.colors(nrow(xyz)))
dev.off()

# Clustering based on 2 states (kmeans clustering, presumably an opened and closed state)
hc <- hclust(dist(pc$z[,1:2]))
grps <- cutree(hc, k=2)
postscript("pca_k2_clustered.eps")
plot(pc, col=grps)
dev.off()

# Contribution to PCs per residue
postscript("pca_1to5_cont.eps")
plot.bio3d(pc$au[,1], ylab="PC3 (A)", xlab="Residue Position", typ="l", lwd=2, col="black")
points(pc$au[,2], typ="l", col="red", lwd=2)
points(pc$au[,3], typ="l", col="purple")
points(pc$au[,4], typ="l", col="green")
points(pc$au[,5], typ="l", col="orange")
dev.off()

postscript("pca_1cont.eps")
plot.bio3d(pc$au[,1], ylab="PC1 (A)", xlab="Residue Position", typ="l", lwd=2, col="black")
dev.off()

postscript("pca_2cont.eps")
plot.bio3d(pc$au[,2], ylab="PC2 (A)", xlab="Residue Position", typ="l", lwd=2, col="red")
dev.off()

postscript("pca_3cont.eps")
plot.bio3d(pc$au[,3], ylab="PC3 (A)", xlab="Residue Position", typ="l", lwd=2, col="purple")
dev.off()

postscript("pca_4cont.eps")
plot.bio3d(pc$au[,4], ylab="PC4 (A)", xlab="Residue Position", typ="l", lwd=2, col="green")
dev.off()

postscript("pca_5cont.eps")
plot.bio3d(pc$au[,4], ylab="PC5 (A)", xlab="Residue Position", typ="l", lwd=2, col="orange")
dev.off()


# Visualize 2 PCs as multi-state PDB files
p1 <- mktrj.pca(pc, pc=1, b=pc$au[,1], file="pc1.pdb")
p2 <- mktrj.pca(pc, pc=2,b=pc$au[,2], file="pc2.pdb")
p3 <- mktrj.pca(pc, pc=3,b=pc$au[,3], file="pc3.pdb")
p4 <- mktrj.pca(pc, pc=4,b=pc$au[,4], file="pc4.pdb")
p5 <- mktrj.pca(pc, pc=5,b=pc$au[,5], file="pc5.pdb")

# Cross-correlation Analysis
cij<-dccm(xyz[,ca.inds$xyz])
postscript("cnma.eps")
plot(cij)
dev.off()

# View the correlations in pymol
# writes a file called R.py and a PDB which you can load in pymol to visualize (warning: takes awhile)
pymol.dccm(cij, pdb, type="script")
