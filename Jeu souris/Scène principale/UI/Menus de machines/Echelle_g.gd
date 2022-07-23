extends "res://Scène principale/UI/Menus de machines/Menu.gd"

signal utilise_echelle ()

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
