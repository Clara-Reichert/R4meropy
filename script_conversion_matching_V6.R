#############################################
#### script principal coordonnées-images ####
#############################################

#### extraction  des coordonnées, date et heure selon la source GNSS ####

#copier-coller ou run le script_omega ou script_multi en fonction du GPS


#### récupération des noms des photos ####
#récupérer les noms des photos
#modifier le chamin d'acces pour que ce soit le chemin du dossier contenant les photos à matcher
Files=list.files(path="C:\\Users\\clare\\Desktop\\Données_stage\\03_06\\Nettoyage0306\\Culture")

#garder uniquement la date et l'heure et mettre au bon format
Files2=as.POSIXlt(Files, format="chassis_%Y-%m-%d_%H.%M.%S.jpg")

#Passer la date et heure au format chaine de caractères (arrive pas à matcher autrement)
pictdata$DateTime2=as.character.Date(pictdata$DateTime)

#### Recherche des correspondances date_heure entre les noms de photos et les coordonnées ####

#Chercher les lignes en commun
M=match(Files2,pictdata$DateTime2)

### construire le nouveau data frame
M2=as.data.frame(M)
M2$Latitude=pictdata[M,1]
M2$Longitude=pictdata[M,2]
M2$d_h=Files2
###

#### Calcul des coordonnées pour lesquelles il n'y a pas de correspondance exacte ####

# moyennes des coordonnées correspondant à l'heure +/- 1 seconde
L=character(length=0)   # liste contenant les indices (positions) des valeurs calculées
c=1                     # compteur du nombre de valeurs calculées
K=                      # compteur du nombre de photos sans coordonnées
l=length(pictdata$DateTime) #longueur du data frame
 
for (i in 1:length(M)){         # parcours toutes les correspondances du matching
  if (is.na(M[i]==T)){          # s'il y a un NA on fait la suite
    K=K+1
    heure=M2[i,4]
    print (heure)
    j=1
    T1=as.numeric(pictdata[1,3])  #première heure du dataframe
    T2=as.numeric(pictdata[l,3])  #dernière heure du dataframe            
    for (j in T1:T2){         
      #j est l'heure en secondes depuis le 1970-01-01
      H1=as.numeric(heure+1)
      H2=as.numeric(heure-1)
      if (H1==j+1 && H2==j-1 ){   #on verifie bien qu'il y a des lignes qui encadrent sont à une seconde près
        print("YES")
        k=1
        for (k in 1:l) {          # on parcours le dataframe de coordonnées pour trouver les lat/lon correspondant à la bonne heur
          
          if(as.numeric(pictdata[k+1,3])==as.numeric(heure+1) && as.numeric(pictdata[k,3])==as.numeric(heure-1)){ 
            print("Calcul")
            M2[i,2]=mean(c(as.numeric(pictdata[k+1,1]),as.numeric(pictdata[k,1])))    #calcule la moyenne des latitudes
            M2[i,3]=mean(c(as.numeric(pictdata[k+1,2]),as.numeric(pictdata[k,2])))    #calcule la moyenne des longitudes
            L[c]=i        # ajoute l'indice à la liste
            c=c+1  
            #sort de la boucle car on a troué les bonnes valeusrs
            break
          }
        }
      } 
    }
  }
}
#### créer des dataframes avec les différents données ####
#ajoute le nom de la photo
M2$nom_images=Files
#arder que les colonnes utiles
M2=subset(M2,select=c(2,3,5))
#coordonnées calculées
M3=M2[L,]
#coordonnées directes
M4=M2[-as.numeric(L) ,]

#### enregistrer les fichiers csv créés ####
write.csv2(M4, file = "Coord_GNSS_images.csv", row.names = FALSE)
write.csv2(M3, file = "Coord_GNSS_calculees_images.csv", row.names = FALSE)

