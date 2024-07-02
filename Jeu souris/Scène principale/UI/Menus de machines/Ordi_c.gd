extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal direct()
signal balayage()
signal projection()

func _on_direct_cout_point(type, index):
	if not (Souris == null):
		var direct = $"Control/VBoxContainer/Direct"
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			direct.Valeur[index] = direct.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if direct.Valeur[index] == 0 :
				direct.Valeur[index] = direct.ValeurMax[index]
				emit_signal("direct")
			$"Control/VBoxContainer/Direct/Compteur".text = str(direct.Valeur[index])


func _on_balayage_cout_point(type, index):
	if not (Souris == null) :
		var balayage = $"Control/VBoxContainer/Balayage" #on note la reference de la barre d'action "balayage"
		if balayage.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				balayage.Valeur[index] = balayage.Valeur[index] - 1
				if balayage.Valeur[0] == 0 and balayage.Valeur[1] == 0 : #si on atteint 0 au compteur
					emit_signal("saut")							#on emet un signal
					balayage.Valeur = balayage.ValeurMax.duplicate()	#on rest les statistique
				balayage.update_affichage()						#on met à jour l'affichage


func _on_projection_cout_point(type, index):
	if not (Souris == null) :
		var projection = $"Control/VBoxContainer/Projection" #on note la reference de la barre d'action "projection"
		if projection.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				projection.Valeur[index] = projection.Valeur[index] - 1
				if projection.Valeur[0] == 0 and projection.Valeur[1] == 0 : #si on atteint 0 au compteur
					emit_signal("projection")							#on emet un signal
					projection.Valeur = projection.ValeurMax.duplicate()	#on rest les statistique
				projection.update_affichage()						#on met à jour l'affichage
