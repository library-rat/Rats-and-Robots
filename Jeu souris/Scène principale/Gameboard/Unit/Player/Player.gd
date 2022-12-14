tool
class_name Player
extends "res://Scène principale/Gameboard/Unit/Unit.gd"
signal saut_fini
export var rsautext = 3 #rayon intérieur de la zone de saut
export var rsautint = 2 #rayon exterieur de la zone de saut
export var limitedash = 5 #distance limite de dash
export var rlimitetir = 5 #rayon  de limite ext de tir en cloche
export var limitetir = 8  #distance limite de tir tendu
var munition : Ammo = null
var aire_tir = [] #stockage des cases d'effet supplémentaires à la case séléctionnée

func _on_AfficheactionActive_move_player(valeur :int) -> void:
	move_range = valeur


func _on_AfficheactionActive_player_neutre():
	move_range = 0
	munition = null
	aire_tir = []

func jump_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	cell = new_cell

func dash_along (old_cell : Vector2,new_cell : Vector2) :
	position = grid.calcul_map_position(new_cell)
	cell = new_cell


func aire_tirC (direction : Vector2, cell_select : Vector2) -> PoolVector2Array :
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

func aire_tirT (direction : Vector2, cell_select : Vector2) -> PoolVector2Array :
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
