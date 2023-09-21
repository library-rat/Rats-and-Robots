extends Control

@onready var ListeMachine = [null,$"Ordi_m",$"Pont (epaule_g)",$"Pont (tete)",$"Pont (epaule_d)",null,$"Gachette",$"Echelle_g",$"Echelle_g",$"Injecteur",$"Visage",$"Chargeur",$"Echelle_d",$"Echelle_d"]



func _on_robot_ouvremachine(numero):
	var menu = get_tree().get_nodes_in_group("Menu_machine")#souris est une liste de toutes les souris
	for m in menu :
		m.visible = false
	ListeMachine[numero - 1].afficher_menu(numero)


func _on_Fin_de_tour_pressed():
	var menu = get_tree().get_nodes_in_group("Menu_machine")#souris est une liste de toutes les souris
	for m in menu :
		m.debut_tour()


func _on_Chargeur_open_gachette():

	$"Chargeur".visible = false
	$"Gachette".afficher_menu($"Gachette".Souris)


func _on_Gachette_open_chargeur():
	$"Gachette".visible = false
	$"Chargeur".afficher_menu($"Chargeur".Souris)



