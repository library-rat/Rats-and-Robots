extends Control

onready var ListeMachine = [null,$"Ordi_m",$"Pont (epaule_g)",$"Pont (tete)",$"Pont (epaule_d)",null,$"Gachette",$"Echelle_g",$"Echelle_g",null,$"Visage",$"Chargeur",$"Echelle_d",$"Echelle_d"]


func _on_Robot_ouvremachine(numero,souris):
	ListeMachine[numero - 1].afficher_menu(souris)


func _on_Fin_de_tour_pressed():
	var menu = get_tree().get_nodes_in_group("Menu_machine")#souris est une liste de toutes les souris
	for m in menu :
		m.debut_tour()

