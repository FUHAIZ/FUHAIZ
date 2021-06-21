#20-Jun-2021 Fuhai Zhou In KAUST
#R version 4.1.0
#data from Dr. Jiayi Zhao and Prof. Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Waxs")
Waxs <- readLines("Waxs.mac")
summary(Waxs)
nchar(Waxs)
length(Waxs)
Waxs_core <- Waxs[5: 47]
Waxs_core
Waxs_before <- Waxs[1:4]
Waxs_after <- Waxs[48]
e <- data.matrix(Waxs_core)
# a <- 2
# a <- as.character(a)
# b <- paste("PE210127_1deglong_WAXS_", a, sep = "000")
# c <- sub("PE210127_1deglong_WAXS_0000", b, Waxs_core)
# g <- data.frame(c)
# f <- rbind(g, g)
# signif(0005, digits = 6)
# Waxs_new <- vector(length = length(Waxs_core) * (2900 + 1))
# Waxs_new
for (i in 1:2900) {
  a <- as.character(i)
  if (i < 10) {
    b <- paste("PE210127_1deglong_WAXS_", a, sep = "000")
  }
  if(i >= 10 &  i < 100){
    b <- paste("PE210127_1deglong_WAXS_", a, sep = "00")
  }
  if(i >= 100 & i < 1000){
    b <- paste("PE210127_1deglong_WAXS_", a, sep = "0")
  }
  if(i > 1000){
    b <- paste("PE210127_1deglong_WAXS_", a, sep = "")
  }  
  c <- sub("PE210127_1deglong_WAXS_0000", b, Waxs_core)
  d <- data.matrix(c)
  e <- rbind(e, d)
}
f <- rbind(data.matrix(Waxs_before), e)
Waxs_new <- rbind(f, data.matrix(Waxs_after))
# Waxs_new_1 <- as.matrix(Waxs_new)
writeLines(Waxs_new, con = "Waxs_new.mac", sep = "\n")
# write.table(Waxs_new, file = "Waxs_new.mac")
