extends Node2D
var MousePop :Array #Permet de stocker la liste de tout les souris disponibles
@export var crew : Crew

signal ouvremachine (numero)


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
	MousePop = get_tree().get_nodes_in_group("Souris")
	for souris in MousePop :
		crew.register_mouse(souris, souris.rest_point +1)
		
	$Ordi_c.ouvrir_menu.connect(_on_ouvrir_menu)
	$Ordi_m.ouvrir_menu.connect(_on_ouvrir_menu)
	$Pont_g.ouvrir_menu.connect(_on_ouvrir_menu)
	$Pont_d.ouvrir_menu.connect(_on_ouvrir_menu)
	$Plasma.ouvrir_menu.connect(_on_ouvrir_menu)
	$Gachette.ouvrir_menu.connect(_on_ouvrir_menu)
	$Echelle_g_h.ouvrir_menu.connect(_on_ouvrir_menu)
	$Echelle_g_b.ouvrir_menu.connect(_on_ouvrir_menu)
	$Injecteur.ouvrir_menu.connect(_on_ouvrir_menu)
	$Visage.ouvrir_menu.connect(_on_ouvrir_menu)
	$Pont_b.ouvrir_menu.connect(_on_ouvrir_menu)
	$Chargeur.ouvrir_menu.connect(_on_ouvrir_menu)
	$Echelle_d_h.ouvrir_menu.connect(_on_ouvrir_menu)
	$Echelle_d_b.ouvrir_menu.connect(_on_ouvrir_menu)

func _input(event):
	if event.is_action_pressed("ui_accept") :
		$FileAction.enleve_action() 
	if event.is_action("ui_page_up"):
		$FileAction.ajoute_action(test)


func _on_ouvrir_menu(numero_machine): #ouvre le menu de la machine
	emit_signal("ouvremachine", numero_machine)
	

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
		var souris = crew.get_mouse($"Echelle_g_b".numero_de_machine)
		$"Echelle_g_h".select(souris)
		$"Echelle_g_b".deselect()
		emit_signal("reset_echelle_g")
		souris.rest_point = $"Echelle_g_h".numero_de_machine - 1
		
	elif ($"Echelle_g_b".libre and not $"Echelle_g_h".libre) :
		var souris = crew.get_mouse($"Echelle_g_h".numero_de_machine)
		$"Echelle_g_b".select(souris)
		$"Echelle_g_h".deselect()
		emit_signal("reset_echelle_g")
		souris.rest_point = $"Echelle_g_b".numero_de_machine - 1



signal reset_echelle_d()
signal reset_echelle_g()

func _on_Echelle_d_utilise_echelle():
	if ($"Echelle_d_h".libre and not $"Echelle_d_b".libre) :
		var souris = crew.get_mouse($"Echelle_d_b".numero_de_machine)
		$"Echelle_d_h".select(souris)
		$"Echelle_d_b".deselect()
		emit_signal("reset_echelle_d")
		souris.rest_point = $"Echelle_d_h".numero_de_machine - 1
		
	elif ($"Echelle_d_b".libre and not $"Echelle_d_h".libre) :
		var souris = crew.get_mouse($"Echelle_d_h".numero_de_machine)
		$"Echelle_d_b".select(souris)
		$"Echelle_d_h".deselect()
		emit_signal("reset_echelle_d")
		souris.rest_point = $"Echelle_d_b".numero_de_machine - 1


signal fermer_pont_tete()
signal fermer_pont_epaule_g()
signal fermer_pont_epaule_d()

func _on_Pont_tete_aller_epaule_d():
	if $"Pont_d".libre and not$"Pont_b".libre:
		var souris = crew.get_mouse($"Pont_b".numero_de_machine)
		$"Pont_d".select(souris)
		$"Pont_b".deselect()
		souris.rest_point = $"Pont_d".numero_de_machine - 1
		emit_signal("fermer_pont_tete")
		

func _on_Pont_tete_aller_epaule_g():
	if $"Pont_g".libre and not$"Pont_b".libre:
		var souris = crew.get_mouse($"Pont_b".numero_de_machine)
		$"Pont_g".select(souris)
		$"Pont_b".deselect()
		souris.rest_point = $"Pont_g".numero_de_machine -1
		emit_signal("fermer_pont_tete")

func _on_Pont_epaule_g_aller_epaule_d():
	if $"Pont_d".libre and not$"Pont_g".libre:
		var souris = crew.get_mouse($"Pont_g".numero_de_machine)
		$"Pont_d".select(souris)
		$"Pont_g".deselect()
		souris.rest_point = $"Pont_d".numero_de_machine -1
		emit_signal("fermer_pont_epaule_g")

func _on_Pont_epaule_g_aller_tete():
	if $"Pont_b".libre and not$"Pont_g".libre:
		var souris = crew.get_mouse($"Pont_g".numero_de_machine)
		$"Pont_b".select(souris)
		$"Pont_g".deselect()
		souris.rest_point = $"Pont_b".numero_de_machine -1
		emit_signal("fermer_pont_epaule_g")


func _on_Pont_epaule_d_aller_epaule_g():
	if $"Pont_g".libre and not$"Pont_d".libre:
		var souris = crew.get_mouse($"Pont_d".numero_de_machine)
		$"Pont_g".select(souris)
		$"Pont_d".deselect()
		souris.rest_point = $"Pont_g".numero_de_machine -1
		emit_signal("fermer_pont_epaule_d")


func _on_Pont_epaule_d_aller_tete():
	if $"Pont_b".libre and not$"Pont_d".libre:
		var souris = crew.get_mouse($"Pont_d".numero_de_machine)
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





