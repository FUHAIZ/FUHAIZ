# R version 4.1.0
# 24-Jun-2021 Fuhai Zhou
# date from Dr. Jiayi Zhao and Prof.Sanjay

# get monitor
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_monitor")
fileName_one <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_monitor")
N <- length(fileName_one)
datalist_one <- vector("list", N)
monitor_position <- c()
monitor <- c()
for (i in 1:N) {
  datalist_one[[i]] <-  readLines(con = fileName_one[i], n = 22)
  monitor_position[i] <- datalist_one[[i]][19]
  monitor[i] <- as.numeric(substring(monitor_position[i], first = 11, last = 16))
  # write.table(datalist[[i]],  file = paste(fileName[i], ".txt"), row.names = FALSE, col.names = FALSE)
}

# get chi
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_bkg")
fileName_two <- dir("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/saxs_bkg")
M <- length(fileName_two)
datalist_two <- vector("list", M)
for (i in 1:M) {
  datalist_two[[i]] <-  read.table(file = fileName_two[i], header = F, skip = 4)
  # write.table(datalist[[i]],  file = paste(fileName[i], ".txt"), row.names = FALSE, col.names = FALSE)
}

# get bkg
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs")
bkg <- read.table(file = "Kapton_BKG_SAXS_0000.chi", header = F, skip = 4)

# get generated data
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Saxs/generated_data")
c <- 0.57 # input your value
q <- 1 # input 1 or 2 or 3; 1: normalize and background; 2: non normalize and background; 3: non normalize and non background
Iq_three <- vector("list", M)
# non_normalize_bkg <- vector("list", M)

for (i in 1:M) {
  if (1 == q) {
    # normalize and background
    Iq_three[[i]] <-  cbind(bkg[, 1], datalist_two[[i]][, 2]/(monitor[i] * c) - bkg[, 2])
    write.table(Iq_three[[i]],  file = paste(fileName_two[i], "_normalize_bkg.txt"), row.names = FALSE, col.names = FALSE)
  }
  if (2 == q) {
    # non normalize and background
    Iq_three[[i]] <-  cbind(bkg[, 1], datalist_two[[i]][, 2]/(monitor[i]) - bkg[, 2])
    write.table(Iq_three[[i]],  file = paste(fileName_two[i], "_non_normalize_bkg.txt"), row.names = FALSE, col.names = FALSE)
  }
  if (3 == q) {
    # non normalize and non background
    Iq_three[[i]] <-  cbind(bkg[, 1], datalist_two[[i]][, 2])
    write.table(Iq_three[[i]],  file = paste(fileName_two[i], "_non_normalize_non_bkg.txt"), row.names = FALSE, col.names = FALSE)
  }
}

install.packages("plyr")
library(plyr)
Iq_peak_total <- data.frame()
Iq2_peak_total <- data.frame()
integrate <- data.frame()
integrate_from <- 1 #input your value
integrate_to <- 1.5 #input your value
for (i in 1:M) {
  Iq <- cbind(Iq_three[[i]][,1], Iq_three[[i]][,2])
  Iq2 <- cbind(Iq_three[[i]][,1], Iq_three[[i]][,2] * Iq_three[[i]][,1] * Iq_three[[i]][,1])
  Is2 <- cbind(Iq_three[[i]][,1]/(2 * pi), Iq_three[[i]][,2] * (Iq_three[[i]][,1]/(2 * pi)) * (Iq_three[[i]][,1]/(2 * pi)))
  Is2_1000 <- Is2[seq(1, length(Is2[,1]), by = ceiling(length(Is2[,1])/1000)),]
  
  # write.table(Iq,  file = paste(fileName_two[i], "_Iq.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Iq2,  file = paste(fileName_two[i], "_Iq2.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Is2,  file = paste(fileName_two[i], "_Is2.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Is2_1000,  file = paste(i-1, ".dat"), row.names = FALSE, col.names = FALSE)
  
  
  Iq_peak <- fileName_two[i]
  for (j in 2:(length(Iq[, 1]) - 1)) {
    if (Iq[j, 2] - Iq[j - 1, 2] > 0 & Iq[j, 2] - Iq[j + 1, 2] > 0) {
      Iq_peak_position <- cbind(Iq[j, 1], 2 * pi / Iq[j, 1])
    }
    Iq_peak <- cbind(Iq_peak, Iq_peak_position)
  }
  Iq_peak_total <- rbind.fill(Iq_peak_total, Iq_peak)

  
  Iq2_peak <- fileName_two[i]
  for (j in 2:(length(Iq2[, 1]) - 1)) {
    if (Iq2[k, 2] - Iq2[k - 1, 2] > 0 & Iq2[k, 2] - Iq2[k + 1, 2] > 0) {
      Iq2_peak_position <- cbind(Iq2[k, 1], 2 * pi / Iq2[k, 1])
    }
    Iq2_peak <- cbind(Iq2_peak, Iq2_peak_position)
  }
  Iq2_peak_total <- rbind.fill(Iq2_peak_total, Iq2_peak)
  
  # get integrate
  for (j in 1:length(Iq2[, 1])) {
    while (Iq2[j,1] < integrate_from) {
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
  integrate[i,1] <- fileName_two[i]
  integrate[i,2] <- s
  
}
write.csv(Iq_peak_total, file = "Iq_peak_total.csv")
write.csv(Iq2_peak_total, file = "Iq2_peak_total.csv")
write.csv(integrate, file = "total_integral.csv")

