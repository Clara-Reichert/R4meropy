#############################################
####     calcul coordonnées éloignées    ####
#############################################
# il faut avoir run le script principal avant celui-ci
# il permet de calculer les coordonnées pour une photo si les coordonénes qui l'encadrent sont éloigéns de plus d'un seconde

#git push -u origin master      (commande git)

#attention, bug quand il y a pas du tout de coordonnées autour, il faut faire commencer à la première coordonnées existante

D=M2      # dataframe contenant le matching
D$d_h=as.POSIXct(D$nom_images , format = "chassis_%Y-%m-%d_%H.%M.%S.jpg")   #mettre la date et l'heure au format POSIXct
l=length (D$Latitude)
L1=character(length=0)      # liste contenant les indices des coordonnées calculées
c=1

#### ATTENTION: il faut faire commencer la boucle à la première coordonnées
for (i in 22:l){     #parcours toutes les images 
  ip=1              # indice qui parcours les coordonnées (pictdata)
  if (is.na(D[i,1]==T)){    #s'il y a pas de latitude
     #trouver les indices de pictdata tel que l'heure soit entourée
     L1[c]=i
     c=c+1
     #Tant que l'heure qu'on recherche n'est pas entre deux horaires conécutives on continue d'augmenter ip
     while(as.numeric(D[i,4])<as.numeric(pictdata[ip,3]) || as.numeric(D[i,4])>as.numeric(pictdata[ip+1,3])) {
       ip=ip+1
       } 
  print("YES")
  
  ## extrait les heures, latitude et longitude  d'avant (1) et d'après (2)
  t1=as.numeric(pictdata[ip,3])
  t2=as.numeric(pictdata[ip+1,3])
  lat1=as.numeric(pictdata[ip,1])
  lat2=as.numeric(pictdata[ip+1,1])
  lon1=as.numeric(pictdata[ip,2])
  lon2=as.numeric(pictdata[ip+1,2])
  
  # on calcule de manière linéaire entre lat ou lon en fonction du temps
  
  ## calcule a et b de ax+b avec a=coeflat et b=Blat pour la latitude
  coeflat=(lat2-lat1)/(t2-t1)
  Blat=lat1-t1*coeflat
  D[i,1]=coeflat*as.numeric(D[i,4])+Blat
  
  ## calcule a et b de ax+b avec a=coeflon et b=Blon pour la longitude
  coeflon=(lon2-lon1)/(t2-t1)
  Blon=lon1-t1*coeflon
  D[i,2]=coeflon*as.numeric(D[i,4])+Blon
  }
}
#garder dans le nvx jeu de données seulement les coordonnées qu'on vient de calculer
D=D[L1,]
#### enregistrer les fichiers csv créés 
write.csv2(D, file = "img_avec_coord_calculees.csv", row.names = FALSE)
