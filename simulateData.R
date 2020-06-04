library(MASS)
n1 <-  100
n2 <-  100
r <- 1

s1 <- 1
s2 <- 0.1
rho <- 0.0
Sigma <- matrix(c(s1^2,rho*s1*s2, rho*s1*s2,s2^2),2,2)
X1 <- mvrnorm(n=n1, c(2, 0), Sigma); 
plot(X1, xlim=c(-5,5), ylim=c(-5,5))

s1 <- 1
s2 <- 1
rho <- 0.9
Sigma <- matrix(c(s1^2,rho*s1*s2, rho*s1*s2,s2^2),2,2)
X2 <- mvrnorm(n=n2, c(2, 2), Sigma); 
points(X2, col='red')

D <- rbind(X1, X2)


write.table(D, 'artificial-data.txt', sep='\t', row.names=F, col.names=F, fileEncoding = 'utf8')

library(mixtools)
out <- regmixEM(x1, x2, k=2)

plot(result, density = TRUE)