#############################################
####              script maïs            ####
#############################################



## lecture du jeu de données ###
#importer le jeu de donnees
pictdata1 <- read.delim("C:\\Users\\clare\\Desktop\\mais\\GPS multispectral\\pictdata_22042000.txt")
pictdata2 <- read.delim("C:\\Users\\clare\\Desktop\\mais\\GPS multispectral\\pictdata_22042001.txt")
pictdata3 <- read.delim("C:\\Users\\clare\\Desktop\\mais\\GPS multispectral\\pictdata_22042002.txt")

pictdata=rbind(pictdata1,pictdata2,pictdata3)
#concatener date et heure
pictdata$DateTime=paste(pictdata$Date,pictdata$X)

#passer dans le format date heure
pictdata$DateTime=as.POSIXct(pictdata$DateTime , format = "%d:%m:%Y %H:%M:%S")

#mettre dans le bon fuseau horaire
pictdata$DateTime=pictdata$DateTime+2*3600

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


#### Analyse des données obtenues par imagej ####
#Lecture des données obtenues par imagej
IMJ<- read.csv("C:/Users/clare/Desktop/IMJ/Summarytest.csv")
IMJ$name=IMJ$Slice
IMJ$IMJ=IMJ$Count
CC=subset(IMJ,select=c(7,8))



Files=list.files(path="C:\\Users\\clare\\Desktop\\mais\\mais_img_preprocessed\\test")
Files=Files[-131]

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="crop_chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caractères (arrive pas à matcher autrement)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)

M=match(Files2,pictdata$DateTime2)
Mi=match(pictdata$DateTime2,Files2)

M2=as.data.frame(M)
M2$Latitude=pictdata[M,1]
M2$Longitude=pictdata[M,2]
M2$d_h=Files2
M2$name=Files
M2$IMJ=CC$IMJ

write.csv2(M2, file = "mais_coord_test.csv", row.names = FALSE)
