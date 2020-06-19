#sans enlever les tabs du jeu de données

#choisir repertoire de travail
setwd("C:/Users/clare/Desktop/R_GNSS/multi")

#importer le jeu de données
pictdata <- read.delim("C:/Users/clare/Desktop/R_GNSS/multi/pictdata_29042000 (1).txt")

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

#enlever les lignes pour lesquelles il n'y a pas de coordonnées (utile?)
pictdata=subset(pictdata,Latitude!="N99:99.9999")

#récupérer les noms des photos
Files=list.files(path="C:\\Users\\clare\\Desktop\\Données_stage\\Nettoyage\\Culture")

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caractères
Files3=as.character.Date(Files2)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)
#####################

#pictdata=pictdata[1:1000,]
#####################
Test=pictdata
T1=Sys.time()
l=length(Files2)
i=0

L=character(length =0 )
for (i in 1:l){        #pour chaque image
  I=Files2[i]                       #on note la date_heure
  j=0
  for (j in 1:length(pictdata$DateTime2)){  #pour chaque coordonnée
    C=pictdata[j,3]                         #on note la date_heure
    if (I==C){                  #on compare
      print(j)
      L[i]=as.character(C)
      break
    }
    Test=Test[-j,]
    ##si il ne trouve pas de coordonées exactes
    
  }
}
T2=Sys.time()
print(T2-T1)

#####################

#enregistrer le fichier csv créé
write.csv2(D, file = "Coord_GNSS_images.csv", row.names = FALSE)