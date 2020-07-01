####################### extraire longitude, latitude et date_heure (pour les données GNSS u=issues du capteur multispectral)

#importer le jeu de donnees
pictdata <- read.delim("C:\\Users\\clare\\Desktop\\R_GNSS\\multi\\pictdata_29042000.txt")

#concatener date et heure
pictdata$DateTime=paste(pictdata$Date,pictdata$X)

#passer dans le format date heure
pictdata$DateTime=as.POSIXct(pictdata$DateTime , format = "%d:%m:%Y %H:%M:%S")

#mettre dans le bon fuseau horaire
pictdata$DateTime=pictdata$DateTime+3600

#renommer les colonnes
pictdata$Latitude=pictdata$GPS
pictdata$Longitude=pictdata$AEX

#choisir les bonnes colonnes
pictdata=subset(pictdata,select=c(8,9,25))

#enlever les lignes pour lesquelles il n'y a pas de coordonnees (utile?)
pictdata=subset(pictdata,Latitude!="N99:99.9999")

#Convertir les coordonees du format N45:12.1234 ? 45.121234 
#pas encore pris en compte N/S ?
#pour la Latitude
########
L=character(length=0)
for ( i in 1:length(pictdata$Latitude)){
  A=as.character(pictdata[i,1])
  B1=as.numeric(substr(A,2,3))
  B2=substr(A,5,6)
  B3=substr(A,8,11)
  B2=as.numeric(paste(B2,B3,sep="."))
  B=B1+B2/60
  if(substr(A,1,1)=="S"){
    B=-B
  }
  
  L[i]=as.double(round(B,6))
}
pictdata$Latitude=L
#######
#pour la longitude
L=character(length=0)
for ( i in 1:length(pictdata$Longitude)){
  A=as.character(pictdata[i,2])
  B1=as.numeric(substr(A,2,4))
  B2=substr(A,6,7)
  B3=substr(A,9,12)
  B2=as.numeric(paste(B2,B3,sep="."))
  B=B1+B2/60
  if(substr(A,1,1)=="O"){
    B=-B
  }
  
  L[i]=as.double(round(B,6))
}
pictdata$Longitude=L
#########################
