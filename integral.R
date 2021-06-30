# R version 4.1.0
# 27-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay
# get integrate 
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_bkg")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_bkg")
M <- length(fileName)
datalist <- vector("list", M)
integrate <- data.frame()
integrate_from <- 1 #input your value
integrate_to <- 1.5 #input your value
for (i in 1:M) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 0)
  Iq2 <- cbind(datalist[[i]][,1], datalist[[i]][,2] * datalist[[i]][,1] * datalist[[i]][,1])

  for (j in 1:length(Iq2[, 1])) {
    if (Iq2[j,1] < integrate_from) {
      position_integrate_from <- j
    }
    
    if (Iq2[j,1] < integrate_to) {
      position_integrate_to <- j
    }
  }
  
  s <- 0
  for (j in (position_integrate_from : position_integrate_to)) {
    s <-  s + (Iq2[j + 1, 1]- Iq2[j, 1])*(Iq2[j, 1]*Iq2[j, 1]*Iq2[j, 2] + Iq2[j + 1, 1]*Iq2[j + 1, 1]*Iq2[j + 1, 2])/2
  }
  integrate[i,1] <- fileName[i]
  integrate[i,2] <- s
  
}
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
write.csv(integrate, file = "total_integral.csv")