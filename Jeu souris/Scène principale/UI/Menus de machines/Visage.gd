extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal coordine_deplacement()


func debut_tour():
	var coordination =$"Control/VBoxContainer/HSplitContainer/Panel/VBoxContainer/Coordination"
	if coordination.Valeur == [0,0] :
		coordination.Valeur = coordination.ValeurMax.duplicate()
		coordination.update_affichage()

#func _on_Calculateur_cout_point(type, index):
#	if not (Souris == null):
#		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
#			var calculateur = $"Control/VBoxContainer/HSplitContainer/Panel/VBoxContainer/Calculateur"
#			calculateur.Valeur[index] = calculateur.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
#			if calculateur.Valeur[index] == 0 :
#				calculateur.Valeur[index] = calculateur.ValeurMax[index]
#				emit_signal("marcher", 2)
#			$"Control/VBoxContainer/HSplitContainer/Panel/VBoxContainer/Calculateur/Compteur".text = str(calculateur.Valeur[index])


func _on_Coordination_cout_point(type, index):
	if not (Souris == null) :
		var coord = $"Control/VBoxContainer/HSplitContainer/Panel/VBoxContainer/Coordination"
		if coord.Valeur[index] > 0:
			if test_souris_stat(type) :
				coord.Valeur[index] = coord.Valeur[index] - 1
				coord.update_affichage()
				if coord.Valeur[0] == 0 and coord.Valeur[1] == 0 :
					 emit_signal("coordine_deplacement")

