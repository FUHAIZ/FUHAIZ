# R version 4.1.0
# 24-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Tlinkam/saxs_Tlinkam")
fileName_one <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Tlinkam/saxs_Tlinkam")
N <- length(fileName_one)
datalist_one <- vector("list", N)
Tlinkam_position <- c()
Tlinkam <- c()
Tlinkam_total <- data.frame()
for (i in 1:N) {
  datalist_one[[i]] <-  readLines(con = fileName_one[i], n = 32)
  Tlinkam_position[i] <- datalist_one[[i]][31]
  Tlinkam[i] <- as.numeric(substring(Tlinkam_position[i], first = 11, last = 17))
  Tlinkam_total[i,1] <- fileName_one[i]
  Tlinkam_total[i,2] <- Tlinkam[i]
}
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Tlinkam")
# write.table(Tlinkam_total,  file = "Tlinkam_total.csv", row.names = FALSE, col.names = FALSE)
write.csv(Tlinkam_total,  file = "Tlinkam_total.csv")
