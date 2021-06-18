#R version 4.1.0
#07-June-2021 Fuhai Zhou
# integrate date from Jiayi Zhao
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Integrate")
SAXA_0000 <- read.table(file = "PE210127_1deglong_SAXS_0001.chi", header = F, skip = 4)
SAXA_0000
length(SAXA_0000)
summary(SAXA_0000)
class(SAXA_0000)
str(SAXA_0000)
head(SAXA_0000)
tail(SAXA_0000)
SAXA_0000[, 1]
SAXA_0000[, 2]
SAXA_0000[[2]]
attach(SAXA_0000)
plot(V1, V2)
plot(V1, V1*V1*V2)
f <- SAXA_0000[, 1]*SAXA_0000[, 1]*SAXA_0000[, 2]
summary(f)
sum(f)
s = 0
for (i in 1:899) {
  s = s + (SAXA_0000[i + 1, 1]-SAXA_0000[i, 1])*abs(SAXA_0000[i, 1]*SAXA_0000[i, 1]*SAXA_0000[i, 2] + SAXA_0000[i + 1, 1]*SAXA_0000[i + 1, 1]*SAXA_0000[i + 1, 2])/2
}
s



#integrate <- function(x,y) {}
#integrate(SAXA_0000[, 1]*SAXA_0000[, 1]*SAXA_0000[, 2], lower = min(SAXA_0000[, 1]), upper = max(SAXA_0000[, 1]))

# fileName <- dir()
# N = length(fileName)
# datalist <- vector("list", N)
# for (i in 1:N) {
#   datalist[[i]] = read.table(file = fileName[i], header = F, skip = 4)
# }
