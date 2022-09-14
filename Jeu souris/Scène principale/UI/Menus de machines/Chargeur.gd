extends "res://Scène principale/UI/Menus de machines/Menu.gd"

var Balle_S = preload("res://Scène principale/Robot/Machines/Munitions/Balle_simple.tres")
var Balle_L = preload("res://Scène principale/Robot/Machines/Munitions/Balle_lourde.tres")
var Balle_P = preload("res://Scène principale/Robot/Machines/Munitions/Balle_paralysante.tres")

var loaded = false
#var chargeur_ouvert = preload ()
#var chargeur_ferme = preload ()

signal charge_munition (ammo)


func _on_ChargerS_cout_point(type, index):
	if not (Souris == null):
		var chars = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerS"
		if !loaded or chars.Valeur[index] > 1 :#si on est pas dans le cas dernier point + munition pleine (on triche sur le fait que chars.Valeur est de taille 1)
			if test_souris_stat(type) :			#verifie si l'on peut enlever des points
				chars.Valeur[index] = chars.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
				if chars.Valeur[index] == 0 :
					chars.Valeur[index] = chars.ValeurMax[index]
					emit_signal("charge_munition", Balle_S)
					loaded = true
				$"Control/HSplitContainer/Panel/VBoxContainer/ChargerS/Compteur".text = str(chars.Valeur[index])

func _on_ChargerL_cout_point(type, index):
	if not (Souris == null):
		var charl = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerL"
		if !loaded or charl.Valeur[index] > 1 :#si on est pas dans le cas dernier point + munition pleine (on triche sur le fait que charl.Valeur est de taille 1)
			if test_souris_stat(type) :			#verifie si l'on peut enlever des points
				charl.Valeur[index] = charl.Valeur[index] - 1	#Valeur est un array pour le cas de multiple type de points
				if charl.Valeur[index] == 0 :
					charl.Valeur[index] = charl.ValeurMax[index]
					emit_signal("charge_munition", Balle_L)
					loaded = true
				$"Control/HSplitContainer/Panel/VBoxContainer/ChargerL/Compteur".text = str(charl.Valeur[index])

func _on_ChargerP_cout_point(type, index):
	if not (Souris == null) :
		var charp = $"Control/HSplitContainer/Panel/VBoxContainer/ChargerP" #on note la reference de la barre d'action "saut"
		if !loaded or (charp.Valeur[0] + charp.Valeur[1]) > 1: #si on est pas dans le cas dernier poit + munition chargée (on utilise que valeur est de taille 2)
			if charp.Valeur[index] > 0:				#si on peut dépenser des points
				if test_souris_stat(type) :			#on teste (et retire les points dans le cas positif)
					charp.Valeur[index] = charp.Valeur[index] - 1
					if charp.Valeur[0] == 0 and charp.Valeur[1] == 0 : #si on atteint 0 au compteur
						emit_signal("charge_munition", Balle_P)							#on emet un signal
						charp.Valeur = charp.ValeurMax.duplicate()	#on rest les statistique
						loaded = true
						#$"Control/HSplitContainer/CenterContainer/TextureRect".texture = chargeur_ferme
					charp.update_affichage()						#on met à jour l'affichage


func _on_Gachette_tir_tendu(ammo):
	loaded = false
	#$"Control/HSplitContainer/CenterContainer/TextureRect".texture = chargeur_ouvert


func _on_Gachette_tir_courbe(ammo):
	loaded = false
	#$"Control/HSplitContainer/CenterContainer/TextureRect".texture = chargeur_ouvert
