extends Node2D

var EquipeListe = [null,null,null,null] #liste des souris
signal ouvremachine (numero,souris)

#func _ready():

func ouvrirmenu (numero_machine,souris) : #ouvre le menu de la machine en lui assignant la souris
	emit_signal("ouvremachine", numero_machine,souris)


func _on_Machine2_ouvrir_menu(numero_machine): #la machine 2 ouvre le lenu de la cabine de pilotage
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])



func _on_Machine2_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris
