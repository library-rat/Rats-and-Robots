extends Node2D
var MousePop :Array #Permet de stocker la liste de tout les souris disponibles
var EquipeListe = [null,null,null,null,null,null,null,null,null,null,null,null,null,null] #liste des souris
signal ouvremachine (numero,souris)
signal init_souris(liste)
func ouvrirmenu (numero_machine,souris) : #ouvre le menu de la machine en lui assignant la souris
	emit_signal("ouvremachine", numero_machine,souris)


#Partie gérant la file d'action
var test = preload("res://Scène principale/Robot/Queue_action/Icon.tres")

var mouvement = preload ("res://Scène principale/Robot/Queue_action/Mouvement.tres")
var saut = preload ("res://Scène principale/Robot/Queue_action/Saut.tres")
var charge = preload ("res://Scène principale/Robot/Queue_action/Charge.tres")
var tendu_simple = preload ("res://Scène principale/Robot/Queue_action/Tir_tendu_simple.tres")
var tendu_lourd = preload ("res://Scène principale/Robot/Queue_action/Tir_tendu_lourd.tres")
var tendu_paralysante = preload ("res://Scène principale/Robot/Queue_action/Tir_tendu_paralysant.tres")
var courbe_simple = preload ("res://Scène principale/Robot/Queue_action/Tir_courbe_simple.tres")
var courbe_lourd = preload ("res://Scène principale/Robot/Queue_action/Tir_courbe_lourd.tres")
var courbe_paralysante = preload ("res://Scène principale/Robot/Queue_action/Tir_courbe_paralysant.tres")

func _ready():
	emit_signal("init_souris", EquipeListe)

func _input(event):
	if event.is_action_pressed("ui_accept") :
		$FileAction.enleve_action() 
	if event.is_action("ui_page_up"):
		$FileAction.ajoute_action(test)

func _on_Ordi_m_marcher(valeur):
	for i in range (valeur) :
		$FileAction.ajoute_action(mouvement)

func _on_Ordi_m_saut():
	$"FileAction".ajoute_action(saut)

func _on_Ordi_m_charge():
	$"FileAction".ajoute_action(charge)

func _on_Gachette_tir_tendu(ammo):
	if ammo.name == "Balle_simple" :
		$"FileAction".ajoute_action(tendu_simple)
	elif ammo.name =="Balle_lourde" :
		$"FileAction".ajoute_action(tendu_lourd)
	elif ammo.name == "Balle_paralysante" :
		$"FileAction".ajoute_action(tendu_paralysante)

func _on_Gachette_tir_courbe(ammo):
	if ammo.name == "Balle_simple" :
		$"FileAction".ajoute_action(courbe_simple)
	elif ammo.name =="Balle_lourde" :
		$"FileAction".ajoute_action(courbe_lourd)
	elif ammo.name == "Balle_paralysante" :
		$"FileAction".ajoute_action(courbe_paralysante)

func _on_FileAction_change_action(action, valeur):
	pass # Replace with function body.



#Partie gérant les échelles et passages

func _on_Echelle_g_utilise_echelle():
	if ($"Echelle_g_h".libre and not $"Echelle_g_b".libre) :
		var souris = EquipeListe[$"Echelle_g_b".numero_de_machine - 1]
		$"Echelle_g_h".select(souris)
		$"Echelle_g_b".deselect()
		emit_signal("reset_echelle_g")
		souris.rest_point = $"Echelle_g_h".numero_de_machine - 1
		
	elif ($"Echelle_g_b".libre and not $"Echelle_g_h".libre) :
		var souris = EquipeListe[$"Echelle_g_h".numero_de_machine - 1]
		$"Echelle_g_b".select(souris)
		$"Echelle_g_h".deselect()
		emit_signal("reset_echelle_g")
		souris.rest_point = $"Echelle_g_b".numero_de_machine - 1



signal reset_echelle_d()
signal reset_echelle_g()

func _on_Echelle_d_utilise_echelle():
	if ($"Echelle_d_h".libre and not $"Echelle_d_b".libre) :
		var souris = EquipeListe[$"Echelle_d_b".numero_de_machine - 1]
		$"Echelle_d_h".select(souris)
		$"Echelle_d_b".deselect()
		emit_signal("reset_echelle_d")
		souris.rest_point = $"Echelle_d_h".numero_de_machine - 1
		
	elif ($"Echelle_d_b".libre and not $"Echelle_d_h".libre) :
		var souris = EquipeListe[$"Echelle_d_h".numero_de_machine - 1]
		$"Echelle_d_b".select(souris)
		$"Echelle_d_h".deselect()
		emit_signal("reset_echelle_d")
		souris.rest_point = $"Echelle_d_b".numero_de_machine - 1


signal fermer_pont_tete()
signal fermer_pont_epaule_g()
signal fermer_pont_epaule_d()

func _on_Pont_tete_aller_epaule_d():
	if $"Pont_d".libre and not$"Pont_b".libre:
		var souris = EquipeListe[$"Pont_b".numero_de_machine - 1]
		$"Pont_d".select(souris)
		$"Pont_b".deselect()
		souris.rest_point = $"Pont_d".numero_de_machine - 1
		emit_signal("fermer_pont_tete")
		

func _on_Pont_tete_aller_epaule_g():
	if $"Pont_g".libre and not$"Pont_b".libre:
		var souris = EquipeListe[$"Pont_b".numero_de_machine - 1]
		$"Pont_g".select(souris)
		$"Pont_b".deselect()
		souris.rest_point = $"Pont_g".numero_de_machine -1
		emit_signal("fermer_pont_tete")

func _on_Pont_epaule_g_aller_epaule_d():
	if $"Pont_d".libre and not$"Pont_g".libre:
		var souris = EquipeListe[$"Pont_g".numero_de_machine - 1]
		$"Pont_d".select(souris)
		$"Pont_g".deselect()
		souris.rest_point = $"Pont_d".numero_de_machine -1
		emit_signal("fermer_pont_epaule_g")

func _on_Pont_epaule_g_aller_tete():
	if $"Pont_b".libre and not$"Pont_g".libre:
		var souris = EquipeListe[$"Pont_g".numero_de_machine - 1]
		$"Pont_b".select(souris)
		$"Pont_g".deselect()
		souris.rest_point = $"Pont_b".numero_de_machine -1
		emit_signal("fermer_pont_epaule_g")


func _on_Pont_epaule_d_aller_epaule_g():
	if $"Pont_g".libre and not$"Pont_d".libre:
		var souris = EquipeListe[$"Pont_d".numero_de_machine - 1]
		$"Pont_g".select(souris)
		$"Pont_d".deselect()
		souris.rest_point = $"Pont_g".numero_de_machine -1
		emit_signal("fermer_pont_epaule_d")


func _on_Pont_epaule_d_aller_tete():
	if $"Pont_b".libre and not$"Pont_d".libre:
		var souris = EquipeListe[$"Pont_d".numero_de_machine - 1]
		$"Pont_b".select(souris)
		$"Pont_d".deselect()
		souris.rest_point = $"Pont_b".numero_de_machine -1
		emit_signal("fermer_pont_epaule_d")

##gère pour recommencer le tour

func _on_Fin_de_tour_pressed():
	var souris = get_tree().get_nodes_in_group("Souris")#souris est une liste de toutes les souris
	for s in souris :
		s.reset_stat()

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



