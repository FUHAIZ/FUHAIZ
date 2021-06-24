# R version 4.1.0
# 20-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/chi/data")
fileName <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/chi/data")
N <- length(fileName)
# total <- data.frame(filename = character(length = N), x = numeric(length = N), y = numeric(length = N))
datalist <- vector("list", N)
for (i in 1:N) {
  datalist[[i]] <-  read.table(file = fileName[i], header = F, skip = 4)
  Iq <- cbind(datalist[[i]]$V1, datalist[[i]]$V2)
  Iq2 <- cbind(datalist[[i]]$V1, datalist[[i]]$V2 * datalist[[i]]$V1 * datalist[[i]]$V1)
  Is2 <- cbind(datalist[[i]]$V1/(2 * pi), datalist[[i]]$V2 * (datalist[[i]]$V1/(2 * pi)) * (datalist[[i]]$V1/(2 * pi)))
  
  write.table(Iq,  file = paste(fileName[i], "_Iq.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Iq2,  file = paste(fileName[i], "_Iq2.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Is2,  file = paste(fileName[i], "_Is2.txt"), row.names = FALSE, col.names = FALSE)
  
  for (j in 2:(length(Iq[, 1]) - 1)) {
    Iq[j, 2] - Iq[j - 1, 2] > 0 & Iq[j, 2] - Iq[j + 1, 2] > 0
    Iq_peak <- cbind(Iq[j, 1], 2 * pi / Iq[j, 1])
    write.table(Iq_peak,  file = paste(fileName[i], "_Iq_peak.txt"), row.names = FALSE, col.names = FALSE)
  }
  
  for (k in 2:(length(Iq2[, 1]) - 1)) {
    Iq[k, 2] - Iq2[k - 1, 2] > 0 & Iq2[k, 2] - Iq2[k + 1, 2] > 0
    Iq2_peak <- cbind(Iq2[k, 1], 2 * pi / Iq2[k, 1])
    write.table(Iq2_peak,  file = paste(fileName[i], "_Iq2_peak.txt"), row.names = FALSE, col.names = FALSE)
  }

  # total$filename[i] <- fileName[i]
  # total$x[i] <- datalist[[i]][, 1]
  # total$y[i] <- datalist[[i]][, 2]
}
# setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Integrate")
# summary(total)
# write.csv(integrate, file = "total_integral.csv")