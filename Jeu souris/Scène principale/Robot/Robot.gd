extends Node2D

var EquipeListe = [null,null,null,null,null,null,null,null,null,null,null,null,null,null] #liste des souris
signal ouvremachine (numero,souris)

#func _ready():

func ouvrirmenu (numero_machine,souris) : #ouvre le menu de la machine en lui assignant la souris
	emit_signal("ouvremachine", numero_machine,souris)


#Partie gérant la file d'action
var test = preload("res://Scène principale/Robot/Queue_action/Icon.tres")

var mouvement = preload ("res://Scène principale/UI/Mouvement.tres")

func _input(event):
	if event.is_action_pressed("ui_accept") :
		$FileAction.enleve_action() 
	if event.is_action("ui_page_up"):
		$FileAction.ajoute_action(test)

func _on_Cabine_de_Pilotage_marcher(valeur):
	for i in range (valeur) :
		$FileAction.ajoute_action(mouvement)


func _on_FileAction_change_action(action, valeur):
	pass # Replace with function body.


#Partie gérant les échelles et passages

func _on_Echelle_g_utilise_echelle():
	if ($"Echelle_g_h".libre and not $"Echelle_g_b".libre) :
		var souris = EquipeListe[$"Echelle_g_b".numero_de_machine - 1]
		$"Echelle_g_h".select(souris)
		$"Echelle_g_b".deselect()
		souris.rest_point = $"Echelle_g_h".numero_de_machine - 1
		
	elif ($"Echelle_g_b".libre and not $"Echelle_g_h".libre) :
		var souris = EquipeListe[$"Echelle_g_h".numero_de_machine - 1]
		$"Echelle_g_b".select(souris)
		$"Echelle_g_h".deselect()
		souris.rest_point = $"Echelle_g_b".numero_de_machine - 1





func _on_Echelle_d_utilise_echelle():
	if ($"Echelle_d_h".libre and not $"Echelle_d_b".libre) :
		var souris = EquipeListe[$"Echelle_d_b".numero_de_machine - 1]
		$"Echelle_d_h".select(souris)
		$"Echelle_d_b".deselect()
		souris.rest_point = $"Echelle_d_h".numero_de_machine - 1
		
	elif ($"Echelle_d_b".libre and not $"Echelle_d_h".libre) :
		var souris = EquipeListe[$"Echelle_d_h".numero_de_machine - 1]
		$"Echelle_d_b".select(souris)
		$"Echelle_d_h".deselect()
		souris.rest_point = $"Echelle_d_b".numero_de_machine - 1

##Toute la partie gérant les signaux des machines

func swap (numero_machine, other_num):
	EquipeListe[numero_machine -1].rest_point = other_num - 1
	EquipeListe[other_num - 1].rest_point = numero_machine - 1
	var stockage = EquipeListe[other_num - 1]
	EquipeListe[other_num - 1] = EquipeListe[numero_machine -1]
	EquipeListe[numero_machine -1] = stockage

func _on_Ordi_c_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Ordi_c_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Ordi_c_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)

func _on_Ordi_m_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Ordi_m_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Ordi_m_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Pont_g_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Pont_g_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Pont_g_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)



func _on_Pont_b_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Pont_b_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Pont_b_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Pont_d_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Pont_d_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Pont_d_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Plasma_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Plasma_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Plasma_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Gachette_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Gachette_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Gachette_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Echelle_g_h_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Echelle_g_h_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Echelle_g_h_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Echelle_g_b_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Echelle_g_b_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Echelle_g_b_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Injecteur_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Injecteur_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Injecteur_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Visage_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Visage_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Visage_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Chargeur_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Chargeur_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Chargeur_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Echelle_d_h_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Echelle_d_h_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Echelle_d_h_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)


func _on_Echelle_d_b_assign_souris(numero_machine, souris):
	EquipeListe[numero_machine-1] = souris


func _on_Echelle_d_b_ouvrir_menu(numero_machine):
	emit_signal("ouvremachine", numero_machine,EquipeListe[numero_machine -1])


func _on_Echelle_d_b_swap_souris(numero_machine, other_num):
	swap(numero_machine, other_num)
