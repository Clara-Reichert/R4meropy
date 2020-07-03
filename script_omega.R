###################################################
### extraire longitude, latitude et date_heure  ###
### (pour les données GNSS issues du GPS omega) ###
###################################################

# les données sont dans deux fichiers différents dans ce cas, il faut donc les combiner (GNSS1 + GNSS2)
# changer les chemins ou se trouvent les fichiers contenant les coordonnées

GNSS1<- read.csv2("C:/Users/clare/R4meropy/gnss_2020-06-03-14-08.txt", sep=",",header=F)
GNSS1=GNSS1[-1,]  #enlever la ligne start
GNSS2<- read.csv2("C:/Users/clare/R4meropy/gnss_2020-06-03-14-42.txt", sep=",",header=F)
GNSS2=GNSS2[-1,]  #enlever la ligne start

#combiner les deux jeux de données (à la suite l'un de l'autre)
GNSS=rbind(GNSS1,GNSS2)

#Nettoyer les données, garder uniquement les informations qui nous interessent (a cause de la mauvaise lecture du jeu de données)
GNSS$Latitude=substr(GNSS$V2,11,20)                                   
GNSS$Longitude=substr(GNSS$V3,13,20)
GNSS$DateTime=substr(GNSS$V6,14,33)
#garder les colonnes qui nous interessent
GNSS=subset(GNSS,select=c("Latitude","Longitude","DateTime"))

#convertir la date et heure au format POSIXct
GNSS$DateTime=as.POSIXct(GNSS$DateTime, format = "%Y-%m-%d-%H-%M-%S")
#correction de l'heure (décalage heure d'été et bon fuseau horaire)
GNSS$DateTime=GNSS$DateTime+2*3600
#nommer le jeu de données pour la suite du script
pictdata=GNSS

#########################