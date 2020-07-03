###############################################################
### extraire longitude, latitude et date_heure              ###
### (pour les données GNSS issues du capteur multispectral) ###
###############################################################

## lecture du jeu de données ###
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

#enlever les lignes pour lesquelles il n'y a pas de coordonnees 
pictdata=subset(pictdata,Latitude!="N99:99.9999")

## Convertir les coordonees de degrés-minute-fraction de minute à degrés décimaux ##
#pour la Latitude
########
L=character(length=0)   #liste qui va contenir les nouelles coordonnées
for ( i in 1:length(pictdata$Latitude)){    #parcours le jeu de données
  A=as.character(pictdata[i,1])   #latitude DMFM
  B1=as.numeric(substr(A,2,3))    #degrés
  B2=substr(A,5,6)                #minutes
  B3=substr(A,8,11)               #fractions de minutes
  #combinaison de minutes et fractions de minutes
  B2=as.numeric(paste(B2,B3,sep="."))
  # conversion de tout en degrés
  B=B1+B2/60
  # prendre en considération N/S => +/-
  if(substr(A,1,1)=="S"){
    B=-B
  }
  L[i]=as.double(round(B,6))
}
#remplacer par les nouvelles latitudes dans le jeu de données
pictdata$Latitude=L
#######
#pour la longitude
L=character(length=0)   #liste qui va contenir les nouelles coordonnées
for ( i in 1:length(pictdata$Longitude)){    #parcours le jeu de données
  A=as.character(pictdata[i,2])   #longitude DMFM
  B1=as.numeric(substr(A,2,4))    #degrés
  B2=substr(A,6,7)                #minutes
  B3=substr(A,9,12)               #fractions de minutes
  #combinaison de minutes et fractions de minutes
  B2=as.numeric(paste(B2,B3,sep="."))
  # conversion de tout en degrés
  B=B1+B2/60
  # prendre en considération E/O => +/-
  if(substr(A,1,1)=="O"){
    B=-B
  }
  
  L[i]=as.double(round(B,6))
}
#remplacer par les nouvelles longitudes dans le jeu de données
pictdata$Longitude=L
#########################
