extends "res://Scène principale/UI/Menus de machines/Menu.gd"

var Balle_S = preload("res://Scène principale/Robot/Machines/Munitions/Balle_simple.tres")
var Balle_L = preload("res://Scène principale/Robot/Machines/Munitions/Balle_lourde.tres")
var Balle_P = preload("res://Scène principale/Robot/Machines/Munitions/Balle_paralysante.tres")

signal charge_munition (ammo)


func _on_ChargerS_cout_point(type, index):
	if not (Souris == null):
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			var chars = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerS"
			chars.Valeur[index] = chars.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if chars.Valeur[index] == 0 :
				chars.Valeur[index] = chars.ValeurMax[index]
				emit_signal("charge_munition", Balle_S)
			$"Control/HSplitContainer/Panel/VBoxContainer/ChargerS/Compteur".text = str(chars.Valeur[index])

func _on_ChargerL_cout_point(type, index):
	if not (Souris == null):
		if test_souris_stat(type) :			#verifie si l'on peut enlever des points
			var charl = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerL"
			charl.Valeur[index] = charl.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
			if charl.Valeur[index] == 0 :
				charl.Valeur[index] = charl.ValeurMax[index]
				emit_signal("charge_munition", Balle_L)
			$"Control/HSplitContainer/Panel/VBoxContainer/ChargerL/Compteur".text = str(charl.Valeur[index])

func _on_ChargerP_cout_point(type, index):
	if not (Souris == null) :
		var charp = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerP" #on note la reference de la barre d'action "saut"
		if charp.Valeur[index] > 0:				#si on peut dépenser des points
			if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
				charp.Valeur[index] = charp.Valeur[index] - 1
				if charp.Valeur[0] == 0 and charp.Valeur[1] == 0 : #si on atteint 0 au compteur
					emit_signal("charge_munition", Balle_P)							#on emet un signal
					charp.Valeur = charp.ValeurMax.duplicate()	#on rest les statistique
				charp.update_affichage()						#on met à jour l'affichage
