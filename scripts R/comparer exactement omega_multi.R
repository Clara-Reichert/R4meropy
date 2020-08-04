#comparaison omega et multi pour le 03/06

multi<- read.csv("C:/Users/clare/R4meropy/csv/multi_direct.csv", sep=";")
omega<- read.csv("C:/Users/clare/R4meropy/csv/omega_direct.csv", sep=";")
multi$d_h=as.POSIXlt(multi$nom_images, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")
omega$d_h=as.POSIXlt(omega$nom_images, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")


c=1
L=character(length=0)
for (i in 1:length(multi$Latitude)){
  if (is.na(multi[i,1]==T)){
    print("yes")
    L[c]=i
    c=c+1
  }
}
multi=multi[-as.numeric(L),]

L=character(length=0)
c=1
for (i in 1:length(omega$Latitude)){
  if (is.na(omega[i,1]==T)){
    print("yes")
    L[c]=i
    c=c+1
  }
}
omega=omega[-as.numeric(L),]

Lo=character(length=0)
Lm=character(length=0)
c=1
for (i in 1:length(multi$Latitude)){
  M=as.numeric(multi$d_h[i])
  for (j in 1:length(omega$Latitude)){
    O=as.numeric(omega$d_h[j])
    if (is.na(omega[j,1])==F && is.na(multi[j,1])==F ){
      if (O==M){
        print(M)
        print(multi$d_h[i])
        print(omega$d_h[j])
        Lo[c]=j
        Lm[c]=i
        c=c+1
      }
    }      
  }
}

multi=multi[Lm,]
omega=omega[Lo,]

write.csv2(multi, file = "multi_exact.csv", row.names = FALSE)
write.csv2(omega, file = "omega_exact.csv", row.names = FALSE)