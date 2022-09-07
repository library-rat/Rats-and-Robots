extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal utilise_echelle ()

var valeur_reset = 1

func debut_tour():
	valeur_reset = 1
	changer_cout(valeur_reset)

func _on_Monter_cout_point(type, index):
	if not (Souris == null):
		var monter =$"Control/VBoxContainer/Monter"
		if monter.Valeur[index] > 0:
			if test_souris_stat(type) :
				monter.Valeur[index] = monter.Valeur[index] -1
				$"Control/VBoxContainer/Monter/Compteur".text = str(monter.Valeur[index])

func _on_Button_pressed():
	if $"Control/VBoxContainer/Monter".Valeur[0] == 0:
		emit_signal("utilise_echelle")

func changer_cout (cout):
	$"Control/VBoxContainer/Monter".Valeur = [cout]
	$"Control/VBoxContainer/Monter/Compteur".text = str(cout)


func _on_Robot_reset_echelle_d():
	changer_cout(valeur_reset)


func _on_Visage_coordine_deplacement():
	valeur_reset = 0
	changer_cout(0)
