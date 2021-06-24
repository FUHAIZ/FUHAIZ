# R version 4.1.0
# 21-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/chi/data")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/chi/data")
N <- length(fileName)
datalist <- vector("list", N)
for (i in 1:N) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 4)
  write.table(datalist[[i]],  file = paste(fileName[i], ".txt"), row.names = FALSE, col.names = FALSE)
}
