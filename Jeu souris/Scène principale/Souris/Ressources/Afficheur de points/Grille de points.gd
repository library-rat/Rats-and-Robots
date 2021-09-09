extends GridContainer


func rafraichir_affichage(Pointliste):
	for point_index in Pointliste.size():
		met_a_jour_afficheur (point_index,Pointliste)
	

func met_a_jour_afficheur (point_index,Pointliste):
	var Afficheur = get_child(point_index)
	var point = Pointliste[point_index]
	Afficheur.affiche_point (point)
	
func point_changee (indexes, Pointliste) :
	for point_index in indexes :
		met_a_jour_afficheur(point_index,Pointliste)
