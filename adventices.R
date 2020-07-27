D=read.csv("C:/Users/clare/R4meropy/toutcalculee.csv", sep=";")
D$adventices=""



adv=list.files(path="D:\\STAGE_MEROPY\\29_04\\5.Chassis_290420_adventices_1606\\adv")
Madv=match(adv,D$nom_images)
D[Madv,5]="adv"

ss_adv=list.files(path="D:\\STAGE_MEROPY\\29_04\\5.Chassis_290420_adventices_1606\\Culture_ss_adv")
Mssadv=match(ss_adv,D$nom_images)
D[Mssadv,5]="sans adv"

write.csv2(D, file = "Repartition_adv.csv", row.names = FALSE)

PP=list.files(path="D:\\STAGE_MEROPY\\29_04\\6.Chassis_290420_adventices_sep_1606\\adv5_petites_pousses")
MPP=match(PP,D$nom_images)
Data=D[MPP,]
write.csv2(Data, file = "petite pousse.csv", row.names = FALSE)

J=list.files(path="D:\\STAGE_MEROPY\\29_04\\6.Chassis_290420_adventices_sep_1606\\adv1_fleur_jaune")
MJ=match(J,D$nom_images)
Data=D[MJ,]
write.csv2(Data, file = "jaune.csv", row.names = FALSE)

B=list.files(path="D:\\STAGE_MEROPY\\29_04\\6.Chassis_290420_adventices_sep_1606\\adv2_bouton_dor")
MB=match(B,D$nom_images)
Data=D[MB,]
write.csv2(Data, file = "bouton d'or.csv", row.names = FALSE)

C=list.files(path="D:\\STAGE_MEROPY\\29_04\\6.Chassis_290420_adventices_sep_1606\\adv3_chardon")
MC=match(C,D$nom_images)
Data=D[MC,]
write.csv2(Data, file = "chardon.csv", row.names = FALSE)

De=list.files(path="D:\\STAGE_MEROPY\\29_04\\6.Chassis_290420_adventices_sep_1606\\adv4_feuilles_plus_découpées_que_bo")
MDe=match(De,D$nom_images)
Data=D[MDe,]
write.csv2(Data, file = "découpé.csv", row.names = FALSE)


