#d:1 -> M2:159 -> pictdata:1758
#git push -u origin master

#pas que les nvlles coordonnées dans le csv

D=M2[159:176,]    #limite le jeu de données à la partie ou il y a des manques (manuel)
D$d_h=as.POSIXct(D$nom_images , format = "chassis_%Y-%m-%d_%H.%M.%S.jpg")
l=length (D$Latitude)

for (i in 1:l){     #parcours D
  ip=1758
  if (is.na(D[i,1]==T)){    #s'il y a pas de latitude
    ##trouver les indices de pictdata tel que l'heure soit entourée
  while(as.numeric(D[i,4])<as.numeric(pictdata[ip,3]) || as.numeric(D[i,4])>as.numeric(pictdata[ip+1,3])) {
    ip=ip+1
  } 
    
  t1=as.numeric(pictdata[ip,3])
  t2=as.numeric(pictdata[ip+1,3])
  lat1=as.numeric(pictdata[ip,1])
  lat2=as.numeric(pictdata[ip+1,1])
  lon1=as.numeric(pictdata[ip,2])
  lon2=as.numeric(pictdata[ip+1,2])
  
  coeflat=(lat2-lat1)/(t2-t1)
  Blat=lat1-t1*coeflat
  D[i,1]=coeflat*as.numeric(D[i,4])+Blat
  
  coeflon=(lon2-lon1)/(t2-t1)
  Blon=lon1-t1*coeflon
  D[i,2]=coeflon*as.numeric(D[i,4])+Blon
  }
}

write.csv2(M2, file = "img_avec_coord_calculees.csv", row.names = FALSE)
