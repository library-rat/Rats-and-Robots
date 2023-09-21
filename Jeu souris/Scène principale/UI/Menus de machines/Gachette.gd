extends "res://Scène principale/UI/Menus de machines/Menu.gd"

var munition
#var image_vide = preload ()

signal tir_tendu (ammo)
signal tir_courbe (ammo)

func debut_tour():
	pass

func _on_TirerT_cout_point(type, index):
	if not (Souris == null):
		var tirt = $"Control/HSplitContainer/Panel/VBoxContainer/TirerT"
		if munition != null or tirt.Valeur[index] > 1 : #si on est pas dans le cas dernier point + munition vide (on triche sur le fait que tirt.Valeur est de taille 1)
			if test_souris_stat(type) :			#verifie si l'on peut enlever des points
				tirt.Valeur[index] = tirt.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
				if tirt.Valeur[index] == 0 :
					tirt.Valeur[index] = tirt.ValeurMax[index]
					emit_signal("tir_tendu", munition)
					munition = null
#					$"Control/HSplitContainer/CenterContainer/TextureRect".texture = image_vide
				$"Control/HSplitContainer/Panel/VBoxContainer/TirerT/Compteur".text = str(tirt.Valeur[index])


func _on_TirerC_cout_point(type, index):
	if not (Souris == null) :
		var tirc = $"Control/HSplitContainer/Panel/VBoxContainer/TirerC" #on note la reference de la barre d'action "saut"
		if munition != null or (tirc.Valeur[0] +tirc.Valeur[1]) > 1 :
			if tirc.Valeur[index] > 0:				#si on peut dépenser des points
				if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
					tirc.Valeur[index] = tirc.Valeur[index] - 1
					if tirc.Valeur[0] == 0 and tirc.Valeur[1] == 0 : #si on atteint 0 au compteur
						tirc.Valeur = tirc.ValeurMax.duplicate()	#on rest les statistique
						emit_signal("tir_courbe", munition)							#on emet un signal
						munition = null
#						$"Control/HSplitContainer/CenterContainer/TextureRect".texture = image_vide
					tirc.update_affichage()						#on met à jour l'affichage


func _on_Chargeur_charge_munition(ammo):
	munition = ammo
	$"Control/HSplitContainer/CenterContainer/TextureRect".texture = munition.texture

signal open_chargeur()
func _on_Button_pressed():
	emit_signal("open_chargeur")
	self.visible = false


func _on_chargeur_open_gachette():
	afficher_menu(numero_machine)
