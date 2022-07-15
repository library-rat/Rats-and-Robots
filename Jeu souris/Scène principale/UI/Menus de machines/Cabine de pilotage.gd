extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal marcher (valeur)

func _on_Marcher_cout_point(type, index):
	if not (Souris == null):
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			var marcher = $"Control/VBoxContainer/Marcher"
			marcher.Valeur[index] = marcher.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if marcher.Valeur[index] == 0 :
				marcher.Valeur[index] = marcher.ValeurMax[index]
				emit_signal("marcher", 2)
			$"Control/VBoxContainer/Marcher/Compteur".text = str(marcher.Valeur[index])
		else : print ("Nope")
