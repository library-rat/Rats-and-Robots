tool
class_name Player
extends "res://Scène principale/Gameboard/Unit/Unit.gd"
signal saut_fini
export var rsautext = 3 #rayon intérieur de la zone de saut
export var rsautint = 2 #rayon exterieur de la zone de saut
export var limitedash = 5 #distance limite de dash
export var rlimitetir = 5 #rayon  de limite ext de tir en cloche
export var limitetir = 8  #distance limite de tir tendu
var munition = null

func _on_AfficheactionActive_move_player(valeur :int) -> void:
	move_range = valeur


func _on_AfficheactionActive_player_neutre():
	move_range = 0
	munition = null

func jump_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	cell = new_cell

func dash_along (old_cell : Vector2,new_cell : Vector2) :
	position = grid.calcul_map_position(new_cell)
	cell = new_cell


func _on_AfficheactionActive_tir_courbe(ammo):
	munition = ammo


func _on_AfficheactionActive_tir_tendu(ammo):
	munition = ammo
