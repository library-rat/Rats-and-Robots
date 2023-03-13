extends Panel

func Affiche_Souris(Souris :Node2D):
	$"HBoxContainer/Grille de points".rafraichir_affichage(Souris.Points)
	$"Machine".text = Souris.rest_nodes
