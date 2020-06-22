D=M2[159:176,]
D$d_h=as.POSIXct(D$nom_images , format = "chassis_%Y-%m-%d_%H.%M.%S.jpg")
l=length (D$Latitude)
T1=D[1,4]
T2=D[l,4]
Lat1=D[1,1]
Lon1=D[1,2]
for (i in 1:l){     #parcours D
  print(Lat1)
  j=i
  while (is.na(D[j,1]==F)){
    j=j+1
  }
  Lat2=D[j,1]
  Lon2=D[j,2]
  if (is.na(D[i,1]==T)){
    
  
  }
  else{
    Lat1=D[i,1]
    Lon1=D[i,2]
  }
}

