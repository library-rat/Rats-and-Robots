extends "res://Scène principale/UI/Menus de machines/Menu.gd"


@onready var Player = get_tree().get_nodes_in_group("Player")[0]#Permet de récupérer une référence à l'unité "Player"


func debut_tour():
	pass





func _on_Fluide_cout_point(type, index):
	if not (Souris == null):
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			var fluide = $"Control/VBoxContainer/Fluide"
			fluide.Valeur[index] = fluide.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if fluide.Valeur[index] == 0 :
				fluide.Valeur[index] = fluide.ValeurMax[index]
				Player.injecte_forme("fluide")
			$"Control/VBoxContainer/Fluide/Compteur".text = str(fluide.Valeur[index])


func _on_Armure_cout_point(type, index):
	if not (Souris == null) :
		var armure = $"Control/VBoxContainer/Armure" #on note la reference de la barre d'action "saut"
		if armure.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				armure.Valeur[index] = armure.Valeur[index] - 1
				if armure.Valeur[0] == 0 and armure.Valeur[1] == 0 : #si on atteint 0 au compteur
					Player.injecte_forme("armure")							#on emet un signal
					armure.Valeur = armure.ValeurMax.duplicate()	#on rest les statistique
				armure.update_affichage()						#on met à jour l'affichage



func _on_Corrosif_cout_point(type, index):
	if not (Souris == null) :
		var corrosif = $"Control/VBoxContainer/Corrosif" #on note la reference de la barre d'action "saut"
		if corrosif.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				corrosif.Valeur[index] = corrosif.Valeur[index] - 1
				if corrosif.Valeur[0] == 0 and corrosif.Valeur[1] == 0 : #si on atteint 0 au compteur
					Player.injecte_forme("corrosive")							#on emet un signal
					corrosif.Valeur = corrosif.ValeurMax.duplicate()	#on rest les statistique
				corrosif.update_affichage()						#on met à jour l'affichage

