tool
class_name Furnace
extends "res://Scène principale/Gameboard/Unit/Enemy/Enemy.gd"
var loading := false

func tire_rayon():
	loading = false
	var target = cell + direction
	while grid.dans_limite(target):
		if board.is_occupied(cell) :
			board.units[cell].is_hit(2)
		target += direction

func play_turn ():
	if loading :
		tire_rayon()
	
