@tool
class_name Player
extends "res://Scène principale/Gameboard/Unit/Unit.gd"
signal saut_fini
@export var rsautext = 3 #rayon intérieur de la zone de saut
@export var rsautint = 2 #rayon exterieur de la zone de saut
@export var limitedash = 5 #distance limite de dash
@export var rlimitetir = 5 #rayon  de limite ext de tir en cloche
@export var limitetir = 8  #distance limite de tir tendu
var munition : Ammo = null
var aire_tir = [] #stockage des cases d'effet supplémentaires à la case séléctionnée
var forme = null #forme du robot donnée par l'injecteur
var armure :int = 0: set = armure_var_set

func end_turn():
	effet_forme()
	if forme != "armure" :
		armure = 0


func begin_turn():
	forme = null


func set_cell(value: Vector2) -> void: #version de set_cell, override the one from Unit
	board.units.erase(cell) #on enleve l'unité à l'ancienne case du dictionnaire
	cell = grid.clamp(value)
	board.units[value] = self #on l'inscrit à la nouvelle case
	board._emit_player_moved()

func _on_AfficheactionActive_move_player(valeur :int) -> void:
	move_range = valeur
	
func effet_forme():
	match forme :
		"armure" :
			if armure < 3 :
				armure += 1
			update_lifebar()
			$"Lifebar".add_armor(armure)

		"fluide" :
			pass
		"corrosive" :
			for i in range(-1,2):
				for j in range(-1,2):
					var target = cell + Vector2(i,j)
					if not(i == 0 and j==0) and board.is_occupied(target):
						board.units[target].is_hit(1)



func _on_AfficheactionActive_player_neutre():
	move_range = 0
	munition = null
	aire_tir = []

func armure_var_set(new_val):
	if new_val > 0:
		armure = new_val
	else:
		armure = 0


func is_hit (valeur : int)  -> void:
	if armure == 0 :
		life = max (0, life - valeur)
	else :
		if armure >= valeur :
			armure -= valeur
		else :
			life = max(0, life+armure - valeur)
			armure = 0
	update_lifebar()

func aire_tirC (direction : Vector2, cell_select : Vector2) -> PackedVector2Array :
		match munition.name :
			"Balle_simple":
				aire_tir = []				
			"Balle_lourde":
				aire_tir = [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]
			"Balle_paralysante":
				aire_tir = [Vector2(0,1), Vector2(0,-1), Vector2(-1,0), Vector2(1,0)]
		var cases_cibles = []
		for c in aire_tir :
			cases_cibles.append(c+cell_select)
		return (cases_cibles)

func aire_tirT (direction : Vector2, cell_select : Vector2) -> PackedVector2Array :
		match munition.name :
			"Balle_simple":
				aire_tir = [direction]				
			"Balle_lourde":
				aire_tir = [direction, 2*direction]
			"Balle_paralysante":
				if direction.x == 0 :
					aire_tir = [ Vector2(1,0),Vector2(-1,0),]
				if direction.y == 0 :
					aire_tir = [ Vector2(0,1), Vector2(0,-1)]
		var cases_cibles = []
		for c in aire_tir :
			cases_cibles.append(c+cell_select)
		return (cases_cibles)
func _on_AfficheactionActive_tir_courbe(ammo):
	munition = ammo

func _on_AfficheactionActive_tir_tendu(ammo):
	munition = ammo

func injecte_forme(new_f : String):
	if forme != null :
		effet_forme() 
	forme = new_f


	
