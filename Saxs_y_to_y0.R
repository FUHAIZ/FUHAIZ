# R version 4.1.0
# 28-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay

# get Iq
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
N <- length(fileName)
datalist <- vector("list", N)

# get yo
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
y0 <- read.table(file = ".dat", header = F, skip = 0) # input your file name

# generate y/yo
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
for (i in 1:N) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 0)
  y_to_y0 <- cbind(datalist[[i]][,1], datalist[[i]][,2]/y0[,2])
  write.table(y_to_y0,  file = paste(fileName[i], "y_to_y0.dat", sep = ""), row.names = FALSE, col.names = FALSE)
}

