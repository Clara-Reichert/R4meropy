#comparaison omega et multi pour le 03/06

#lire les jeux de données
multi<- read.csv("C:/Users/clare/R4meropy/csv/multi_direct.csv", sep=";")
omega<- read.csv("C:/Users/clare/R4meropy/csv/omega_direct.csv", sep=";")

# convertir le nom de l'image en date-heure 
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

### enlever les lignes sans coordonées pour omega ###
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


MatchO=match(multi$d_h,omega$d_h)
MatchM=match(omega$d_h,multi$d_h)

omega=omega[MatchO,]
multi=multi[MatchM,]



write.csv2(multi, file = "multi_exact.csv", row.names = FALSE)
write.csv2(omega, file = "omega_exact.csv", row.names = FALSE)