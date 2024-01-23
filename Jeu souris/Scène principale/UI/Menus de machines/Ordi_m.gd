extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal marcher (valeur)
signal charge ()
signal saut () 

func debut_tour():
	pass

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


func _on_Charge_cout_point(type, index):
	if not (Souris == null):
		var charge = $"Control/VBoxContainer/Charge"
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			charge.Valeur[index] = charge.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if charge.Valeur[index] == 0 :
				charge.Valeur[index] = charge.ValeurMax[index]
				emit_signal("charge")
			$"Control/VBoxContainer/Charge/Compteur".text = str(charge.Valeur[index])


func _on_saut_cout_point(type, index):
	if not (Souris == null) :
		var saut = $"Control/VBoxContainer/Saut" #on note la reference de la barre d'action "saut"
		if saut.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				saut.Valeur[index] = saut.Valeur[index] - 1
				if saut.Valeur[0] == 0 and saut.Valeur[1] == 0 : #si on atteint 0 au compteur
					emit_signal("saut")							#on emet un signal
					saut.Valeur = saut.ValeurMax.duplicate()	#on rest les statistique
				saut.update_affichage()						#on met à jour l'affichage

