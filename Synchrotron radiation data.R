#28-May-2021 Fuhai Zhou In KAUST
#R version 4.1.0
#Synchrotron radiation data from Jiayi Zhao and Prof.Sanjay
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Synchrotron radiation data")
srd_0701_0800 <- readLines("0701_0800.txt")
summary(srd_0701_0800)
nchar(srd_0701_0800)
length(srd_0701_0800)
grep <- grep("PE210127_1deglong_SAXS_", text)
grep
length(grep)
#regexpr("PE210127_1deglong_SAXS_", text)
grep_07_08 <- sub("PE210127_1deglong_SAXS_08", "PE210127_1deglong_SAXS_09", srd_0701_0800)
grep_07_08.08_09 <- sub("PE210127_1deglong_SAXS_07", "PE210127_1deglong_SAXS_08", grep_07_08)
srd_0801_0900 <- grep_07_08.08_09
writeLines(srd_0801_0900, con = "0801_0900.mac", sep = "\n")
writeLines(srd_0801_0900, con = "0801_0900.txt", sep = "\n")
srd_0801_0900 <- readLines("0801_0900.mac")
summary(srd_0801_0900)
##
##
##
#srd_0701_0800[grep]
#srd_0701_0800[grep][300]
#te <- as.character("09")


####### For batch processing
setwd("C:/Users/FUHAIZ/Desktop/R KAUST/Synchrotron radiation data")
srd_0701_0800 <- readLines("0701_0800.txt")
for (i in 1:98) {
  if (i < 9) {
    a <- as.character(i + 1)
    b <- paste("PE210127_1deglong_SAXS_", a, sep = "0")
    c <- sub("PE210127_1deglong_SAXS_08", b, srd_0701_0800)
    d <- as.character(i)
    e <- paste("PE210127_1deglong_SAXS_", d, sep = "0")
    f <- sub("PE210127_1deglong_SAXS_07", e, c)
    g <- i*100 + 1
    g.1 <- as.character(g)
    h <- (i+1)*100
    h.1 <- as.character(h)
    m <- paste("0", g.1, sep = "")
    n <- paste(m, h.1, sep = "_0")
    k <- paste(n, ".txt", sep = "")
    k.1 <- paste("str_", k, sep = "")
    writeLines(f, con = k.1, sep = "\n")
  }
  if(i == 9){
    a <- as.character(i + 1)
    b <- paste("PE210127_1deglong_SAXS_", a, sep = "")
    c <- sub("PE210127_1deglong_SAXS_08", b, srd_0701_0800)
    d <- as.character(i)
    e <- paste("PE210127_1deglong_SAXS_", d, sep = "0")
    f <- sub("PE210127_1deglong_SAXS_07", e, c)
    g <- i*100 + 1
    g.1 <- as.character(g)
    h <- (i+1)*100
    h.1 <- as.character(h)
    m <- paste("0", g.1, sep = "")
    n <- paste(m, h.1, sep = "_")
    k <- paste(n, ".txt", sep = "")
    k.1 <- paste("str_", k, sep = "")
    writeLines(f, con = k.1, sep = "\n")
  }
  if(i >= 10){
    a <- as.character(i + 1)
    b <- paste("PE210127_1deglong_SAXS_", a, sep = "")
    c <- sub("PE210127_1deglong_SAXS_08", b, srd_0701_0800)
    d <- as.character(i)
    e <- paste("PE210127_1deglong_SAXS_", d, sep = "")
    f <- sub("PE210127_1deglong_SAXS_07", e, c)
    g <- i*100 + 1
    g.1 <- as.character(g)
    h <- (i+1)*100
    h.1 <- as.character(h)
    m <- paste("", g.1, sep = "")
    n <- paste(m, h.1, sep = "_")
    k <- paste(n, ".txt", sep = "")
    k.1 <- paste("str_", k, sep = "")
    writeLines(f, con = k.1, sep = "\n")
  }
}






