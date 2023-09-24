extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal aller_tete ()
signal aller_epaule_g ()
var coord = false #permet de savoir si les transports sont gratuits

func debut_tour():
	coord = false
	fermer_pont()

func _on_Ouvrir_porte_cout_point(type, index):
	if not (Souris == null):
		var ouvrir =$"Control/VBoxContainer/Ouvrir_porte"
		if ouvrir.Valeur[index] > 0:
			if test_souris_stat(type) :
				ouvrir.Valeur[index] = ouvrir.Valeur[index] -1
				$"Control/VBoxContainer/Ouvrir_porte/Compteur".text = str(ouvrir.Valeur[index])
			if ouvrir.Valeur[index] == 0 :
				ouvrir.visible = false
				$"Control/VBoxContainer/Pont_1".visible = true
				$"Control/VBoxContainer/Pont_2".visible = true


func _on_passage_1_pressed():
	emit_signal("aller_tete")


func _on_passage_2_pressed():
	emit_signal("aller_epaule_g")


func _on_robot_fermer_pont_epaule_d():
	fermer_pont()

func fermer_pont():
	visible = false
	if not coord :
		var maxvaleur = $"Control/VBoxContainer/Ouvrir_porte".ValeurMax
		$"Control/VBoxContainer/Ouvrir_porte".Valeur = maxvaleur.duplicate()
		$"Control/VBoxContainer/Ouvrir_porte/Compteur".text = str(maxvaleur[0])
		$"Control/VBoxContainer/Ouvrir_porte".visible = true
		$"Control/VBoxContainer/Pont_1".visible = false
		$"Control/VBoxContainer/Pont_2".visible = false



func _on_visage_coordine_deplacement():
	$"Control/VBoxContainer/Ouvrir_porte".visible = false
	$"Control/VBoxContainer/Pont_1".visible = true
	$"Control/VBoxContainer/Pont_2".visible = true
	coord = true


