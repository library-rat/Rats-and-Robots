extends Control

onready var ListeMachine = [null,$"Cabine de Pilotage",null,null]


func _on_Robot_ouvremachine(numero,souris):
	ListeMachine[numero - 1].afficher_menu(souris)
