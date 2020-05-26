# Load data
args <- commandArgs(trailingOnly = TRUE)
DATA.FILE <- args[1]
Y <- read.table(DATA.FILE, header=TRUE, check.names=FALSE)

# Get the gene expression levels for the firt two genes
g1 <- t(Y[1,]) # t means transpose
g2 <- t(Y[2,]) 

# Compute correlation coeffcient
r <- cor(g1, g2) # correlation coefficient between g1 and g2 when use all conditions

# Take logarithm before computing correlation coeffcient
r2 <- cor(log(g1), log(g2)) # take log first

as.vector(g1) # convert g1 to a pure vector

gene.ids <- rownames(Y) # get all gene names
cond.ids <- colnames(Y) # get all column names, i.e., conditions

# Check all gene pairs
library(mixtools)
find_component <- function(g1, g2, x1, x2,  K) { 
   
   result <- regmixEM(x1, x2, k=K)
   category <- apply(result$posterior, 1, which.max)
   for (c in unique(category)) {
      index <- which(category == c)
      r <- cor(x1[index], x2[index])
      if (!is.na(r) & abs(r) > 0.5) {
         print(sprintf(' %s,  %s, r=%4.2f, n=%d, cond=%s,
                       log.likelihood=%4.2f', g1, g2, r, length(index), paste(colnames(Y)[index],collapse=" "),
                       result$loglik))
      }
   }
   
}


Y <- log(Y)
v <- apply(Y, 1, var) # variance for reach row
v <- as.vector(v)
v[is.na(v)] <- 0
keep.index <- which(v > 1)
Y <- Y[keep.index, ]
num.genes <- min(dim(Y)[1], 1000)

for (i in 1:(num.genes-1)) {
   for (j in (i+1):num.genes) {
      id1 <- gene.ids[i]
      id2 <- gene.ids[j]
      x1 <- as.vector(t(Y[i,]))
      x2 <- as.vector(t(Y[j,]))
      r <- cor(x1, x2)
      if (!is.na(r) & abs(r) > 0.5) { # show the result if correlation coefficient is greater than 0.5
         result <- sprintf("Gene1:%s, gene2:%s, correlation coefficient: %4.2f", id1, id2, r)
         print(result)
      } else if (!is.na(r)) {
         find_component(id1, id2, x1, x2, 2)
      }
   }
}

