#R version 4.1.0
#07-June-2021 Fuhai Zhou
# integrate saxsdate from Jiayi Zhao
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Integrate/saxs-0610")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Integrate/saxs-0610")
N <- length(fileName)
integrate <- data.frame(filename = character(length = N), integral = numeric(length = N))
datalist <- vector("list", N)
for (i in 1:N) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 4)
  # m <- length(datalist[[i]]$V1)
  s <- 0
  # for (j in 1:(m - 1)) {
  for (j in 1:(274 - 1)) {
    s <-  s + (datalist[[i]][j + 1, 1]- datalist[[i]][j, 1])*(datalist[[i]][j, 1]*datalist[[i]][j, 1]*datalist[[i]][j, 2] + datalist[[i]][j + 1, 1]*datalist[[i]][j + 1, 1]*datalist[[i]][j + 1, 2])/2
  }
  integrate$filename[i] <- fileName[i]
  integrate$integral[i] <- s
}
# setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Integrate")
write.csv(integrate, file = "total_integral.csv")

