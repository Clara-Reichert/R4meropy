IMJ<- read.csv("C:/Users/clare/Desktop/IMJ/SummaryV46.csv")
C<- read.csv("C:/Users/clare/Desktop/mais/mais_csv/mais_train_counted2.csv", sep=";")
C=C[-23,]
M=match(C$name, IMJ$Slice)
C$imagej=IMJ$Count
C$diff=C$tag-C$imagej
moyabs=mean(abs(C$diff)) 
moy=mean(C$diff)

X=subset(C, diff==0)


