#git push -u origin master
#choisir repertoire de travail
setwd("C:/Users/clare/R4meropy")

#importer le jeu de donnees
pictdata <- read.delim("C:/Users/clare/R4meropy/pictdata_03062000.txt")

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
  B2=as.numeric(substr(A,5,6))
  B3=as.numeric(substr(A,8,9))
  B4=as.numeric(substr(A,10,11))
  B3=as.numeric(paste(B3,B4,sep="."))
  B=B1+B2/60+B3/3600
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
  B2=as.numeric(substr(A,6,7))
  B3=as.numeric(substr(A,9,10))
  B4=as.numeric(substr(A,11,12))
  B3=as.numeric(paste(B3,B4,sep="."))
  B=B1+B2/60+B3/3600
  if(substr(A,1,1)=="O"){
    B=-B
  }

  L[i]=as.double(round(B,6))
}
pictdata$Longitude=L
##########


#récupérer les noms des photos
Files=list.files(path="C:\\Users\\clare\\Desktop\\Données_stage\\03_06\\Nettoyage0306\\Culture")

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caractères (arriver pas à matcher autrement)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)

#Chercher les lignes en commun
M=match(Files2,pictdata$DateTime2)

### construire le nouveau data frame
M2=as.data.frame(M)
M2$Latitude=pictdata[M,1]
M2$Longitude=pictdata[M,2]
M2$d_h=Files2
###

###############################

i=1
L=character(length=0)
c=1
K=0
l=length(pictdata$DateTime)
for (i in 1:length(M)){
  if (is.na(M[i]==T)){
    K=K+1
    heure=M2[i,4]
    print (heure)
    j=1
    T1=as.numeric(pictdata[1,3])
    T2=as.numeric(pictdata[l,3])              
    for (j in T1:T2){         #j est l'heure en secondes depuis le 1970-01-01
      H1=as.numeric(heure+1)
      H2=as.numeric(heure-1)
      if (H1==j+1 && H2==j-1 ){
        print("YES")
        ## l'horaire manquante est bien entour? ? une seconde pr?s de coordonn?es, on peut faire la moyenne
        k=1
        for (k in 1:l) {
          
          if(as.numeric(pictdata[k+1,3])==as.numeric(heure+1) && as.numeric(pictdata[k,3])==as.numeric(heure-1)){ 
            print("Maybe")
            print(k)
            print(pictdata[k+1,3])
            print(pictdata[k,3])
            print(i)
            print(as.numeric(pictdata[k+1,1]))
            print(as.numeric(pictdata[k,1]))
            print(as.numeric(pictdata[k+1,2]))
            print(as.numeric(pictdata[k,2]))
            #hyp: On est dans un carré assez petit pour que la moyenne soit ? peu pr?s juste???
            print(mean(c(as.numeric(pictdata[k+1,1]),as.numeric(pictdata[k,1]))))
            M2[i,2]=mean(c(as.numeric(pictdata[k+1,1]),as.numeric(pictdata[k,1])))
            M2[i,3]=mean(c(as.numeric(pictdata[k+1,2]),as.numeric(pictdata[k,2])))
            L[c]=i
            c=c+1
            break
          }
        }
      } 
    }
  }
}
###############################
M2$nom_images=Files
#enlever les colonnes inutiles
M2=subset(M2,select=c(2,3,5))
M3=M2[L,]
M4=M2[-as.numeric(L) ,]

#enregistrer le fichier csv créé
write.csv2(M2, file = "Coord_GNSS_images.csv", row.names = FALSE)
#enregistrer le fichier csv créé
write.csv2(M4, file = "Coord_GNSS_calculees_images.csv", row.names = FALSE)