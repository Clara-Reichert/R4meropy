GNSS1<- read.csv2("C:/Users/clare/R4meropy/gnss_2020-06-03-14-08.txt", sep=",",header=F)
GNSS1=GNSS1[-1,]
GNSS2<- read.csv2("C:/Users/clare/R4meropy/gnss_2020-06-03-14-42.txt", sep=",",header=F)
GNSS2=GNSS2[-1,]
GNSS=rbind(GNSS1,GNSS2)
GNSS$Latitude=substr(GNSS$V2,11,20)                                   
GNSS$Longitude=substr(GNSS$V3,13,20)
GNSS$d_h=substr(GNSS$V6,14,33)
GNSS=subset(GNSS,select=c("Latitude","Longitude","d_h"))
GNSS$d_h=as.POSIXct(GNSS$d_h, format = "%Y-%m-%d-%H-%M-%S")
GNSS$d_h=GNSS$d_h+3600           
