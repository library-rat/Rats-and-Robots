extends Control

onready var ListeMachine = [null,$"Ordi_m",null,null,null,null,null,$"Echelle_g",$"Echelle_g",null,null,null,$"Echelle_d",$"Echelle_d"]


func _on_Robot_ouvremachine(numero,souris):
	ListeMachine[numero - 1].afficher_menu(souris)
