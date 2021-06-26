# R version 4.1.0
# 25-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/cor/data")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/cor/data")
N <- length(fileName)
datalist <- vector("list", N)
# total_one <- data.frame()
total <- data.frame(filename = character(), x1 = double(), x2 = double(), ratio = double(), intercept = double())
# total <- data.frame()
for (i in 1:N) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 0)
  M <- length(datalist[[i]][, 1])
  total_one <- data.frame()
  for (j in 1:M) {
    if (min(datalist[[i]][,2]) == datalist[[i]][j,2]) {
      L <- j
    }
  }
  slope <- data.frame()
  for (k in 1:(L-1)) {
    slope[k,1] <- (datalist[[i]][k+1,2] - datalist[[i]][k,2])/(datalist[[i]][k+1,1] - datalist[[i]][k,1])
    if (min(slope[,1]) == slope[k, 1]) {
      intercept <- datalist[[i]][k,2] - (slope[k,1]*datalist[[i]][k,1])
      # peak_position_1 <- (datalist[[i]][L,2] - intercept)/slope[k,1]
      peak_position_1 <- (min(datalist[[i]][,2]) - intercept)/min(slope[,1])
    }
  }
  peak <- data.frame()
  for (h in L:M) {
    if (datalist[[i]][h, 2] - datalist[[i]][h - 1, 2] > 0 & datalist[[i]][h, 2] - datalist[[i]][h + 1, 2] > 0) {
      peak <- cbind(peak[1,], datalist[[i]][h, 1])
    }
  }
  peak_position_2 <- peak[1,1]
  ratio <- peak_position_1/peak_position_2
  # total_one <- cbind(as.data.frame(fileName[i]), as.data.frame(peak_position_1), as.data.frame(peak_position_2), as.data.frame(ratio), as.data.frame(intercept))
  total_one <- cbind(fileName[i], peak_position_1, peak_position_2, ratio, intercept)
  total <- rbind(total, total_one)
}
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/cor/results")
names(total)[1:5] <- c("filename", "x1", "x2", "x1/x2", "intercept")
# write.table(total,  file = "total_1.csv", row.names = FALSE, col.names = T, sep = "/n")
write.csv(total, file = "total.csv")



# attach(datalist[[1]])
# plot(datalist[[1]])
# attach(datalist[[2]])
# plot(datalist[[2]])

