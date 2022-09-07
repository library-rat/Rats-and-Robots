extends "res://Scène principale/UI/Menus de machines/Menu.gd"

var munition
#var image_vide = preload ()

signal tir_tendu (ammo)
signal tir_courbe (ammo)

func _on_TirerT_cout_point(type, index):
	if not (Souris == null):
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			var tirt = $"Control/HSplitContainer/Panel/VBoxContainer/TirerT"
			tirt.Valeur[index] = tirt.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if tirt.Valeur[index] == 0 :
				tirt.Valeur[index] = tirt.ValeurMax[index]
				emit_signal("tir_tendu", munition)
				munition = null
#				$"Control/HSplitContainer/CenterContainer/TextureRect".texture = image_vide
			$"Control/HSplitContainer/Panel/VBoxContainer/TirerT/Compteur".text = str(tirt.Valeur[index])


func _on_TirerC_cout_point(type, index):
	if not (Souris == null) :
		var tirc = $"Control/HSplitContainer/Panel/VBoxContainer/TirerC" #on note la reference de la barre d'action "saut"
		if tirc.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				tirc.Valeur[index] = tirc.Valeur[index] - 1
				if tirc.Valeur[0] == 0 and tirc.Valeur[1] == 0 : #si on atteint 0 au compteur
					tirc.Valeur = tirc.ValeurMax.duplicate()	#on rest les statistique
					emit_signal("tir_courbe", munition)							#on emet un signal
					munition = null
#					$"Control/HSplitContainer/CenterContainer/TextureRect".texture = image_vide
				tirc.update_affichage()						#on met à jour l'affichage


func _on_Chargeur_charge_munition(ammo):
	munition = ammo
	$"Control/HSplitContainer/CenterContainer/TextureRect".texture = munition.texture
