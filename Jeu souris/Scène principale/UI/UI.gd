extends Control

onready var ListeMachine = [null,$"Cabine de Pilotage",null,null]


func _on_Robot_ouvremachine(numero,souris):
	print (numero - 1)
	ListeMachine[numero - 1].afficher_menu(souris)
