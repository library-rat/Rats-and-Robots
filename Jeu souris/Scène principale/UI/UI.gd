extends Control

@onready var ListeMachine = [null,$"Ordi_m",$"Pont (epaule_g)",$"Pont (tete)",$"Pont (epaule_d)",null,$"Gachette",$"Echelle_g",$"Echelle_g",$"Injecteur",$"Visage",$"Chargeur",$"Echelle_d",$"Echelle_d"]

func _ready():
	EventSingleton.connect("begin_turn_player", _on_debut_de_tour)

func _on_robot_ouvremachine(numero):
	var menu = get_tree().get_nodes_in_group("Menu_machine")#souris est une liste de toutes les souris
	for m in menu :
		m.visible = false
	ListeMachine[numero - 1].afficher_menu(numero)


func _on_fin_de_tour_pressed():
	$"Fin_de_tour/Cache".visible = true
	EventSingleton.emit_signal("end_turn_player")
	var menu = get_tree().get_nodes_in_group("Menu_machine")#souris est une liste de toutes les souris
	for m in menu :
		m.debut_tour()
	
	
func  _on_debut_de_tour():
		$"Fin_de_tour/Cache".visible = false
