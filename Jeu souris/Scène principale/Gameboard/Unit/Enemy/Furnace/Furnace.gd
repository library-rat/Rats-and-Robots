tool
class_name Furnace
extends "res://Scène principale/Gameboard/Unit/Enemy/Enemy.gd"
var loading := false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func tire_rayon():
	loading = false
	var target = cell + direction
	while grid.dans_limite(target):
		if board.is_occupied(target) :
			board.units[target].is_hit(2)
			print(board.units[target])
		target += direction

func play_turn ():
	var playercell = board.position_player()
	if loading :
		tire_rayon()
	var targetcells = board.remplir_case_cercle(playercell, 5,3,false)
	var possiblecells = board.remplir_case_move(cell, move_range)
	var selected_cell = []
	for new_cell in targetcells :
		if new_cell in possiblecells :
			selected_cell.append(new_cell)
	var dif : Vector2 = (playercell - cell)
	var distance := int(abs(dif.x) + abs(dif.y))
	if abs(dif.x) < abs(dif.y) :
		direction = Vector2(0, (dif.y/abs(dif.y)))
	else :
		direction = Vector2((dif.x/abs(dif.x)), 0)
		
	if selected_cell == [] :
		if distance < 3 :
			direction = - direction
		selected_cell.append(cell + move_range*direction)
	else :
		loading = true
		$"PathFollow2D/Sprite".modulate = Color(0, 0, 1)
	var indice = rng.randi_range(0,len(selected_cell) - 1)
	move_along(cell,selected_cell[indice])

func move_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	cell = new_cell
