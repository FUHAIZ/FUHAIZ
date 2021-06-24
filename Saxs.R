# R version 4.1.0
# 21-Jun-2021 Fuhai Zhou
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

integrate <- data.frame()
for (i in 1:M) {
  Iq <- cbind(Iq_three[[i]][,1], Iq_three[[i]][,2])
  Iq2 <- cbind(Iq_three[[i]][,1], Iq_three[[i]][,2] * Iq_three[[i]][,1] * Iq_three[[i]][,1])
  Is2 <- cbind(Iq_three[[i]][,1]/(2 * pi), Iq_three[[i]][,2] * (Iq_three[[i]][,1]/(2 * pi)) * (Iq_three[[i]][,1]/(2 * pi)))
  
  # write.table(Iq,  file = paste(fileName_two[i], "_Iq.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Iq2,  file = paste(fileName_two[i], "_Iq2.txt"), row.names = FALSE, col.names = FALSE)
  write.table(Is2,  file = paste(fileName_two[i], "_Is2.txt"), row.names = FALSE, col.names = FALSE)
  
  
  
  # for (j in 2:(length(Iq[, 1]) - 1)) {
  #   if (Iq[j, 2] - Iq[j - 1, 2] > 0 & Iq[j, 2] - Iq[j + 1, 2] > 0) {
  #     Iq_peak <- cbind(Iq[j, 1], 2 * pi / Iq[j, 1])
  #     write.table(Iq_peak,  file = paste(fileName_two[i], "_Iq_peak.txt"), row.names = FALSE, col.names = FALSE)
  #   }
  # 
  # }
  # 
  # 
  # for (j in 2:(length(Iq2[, 1]) - 1)) {
  #   if (Iq2[k, 2] - Iq2[k - 1, 2] > 0 & Iq2[k, 2] - Iq2[k + 1, 2] > 0) {
  #     Iq2_peak <- cbind(Iq2[k, 1], 2 * pi / Iq2[k, 1])
  #     write.table(Iq2_peak,  file = paste(fileName_two[i], "_Iq2_peak.txt"), row.names = FALSE, col.names = FALSE)
  #   }
  # }
  
  
  s <- 0
  for (j in (1:length(Iq2[, 1]) -1)) {
    s <-  s + (Iq2[j + 1, 1]- Iq2[j, 1])*(Iq2[j, 1]*Iq2[j, 1]*Iq2[j, 2] + Iq2[j + 1, 1]*Iq2[j + 1, 1]*Iq2[j + 1, 2])/2
  }
  integrate[i,1] <- fileName_two[i]
  integrate[i,2] <- s
  
}
write.csv(integrate, file = "total_integral.csv")




