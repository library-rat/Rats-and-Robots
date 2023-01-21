tool
class_name Furnace
extends "res://Scène principale/Gameboard/Unit/Enemy/Enemy.gd"
var loading := false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func charge_rayon():
		loading = true
		$"PathFollow2D/Sprite".modulate = Color(0, 0, 1)
		var target = cell + direction
		while grid.dans_limite(target):
			board.add_threat(target,self)
			target += direction

func tire_rayon():
	loading = false
	var target = cell + direction
	while grid.dans_limite(target):
		if board.is_occupied(target) :
			board.units[target].is_hit(2)
		target += direction

func play_turn ():
	print(board.units.size())
	var playercell = board.position_player()
	if loading :
		tire_rayon()
		print('shoot')
	var targetcells = board.remplir_case_cercle(playercell, 5,3,false)
	var possiblecells = board.remplir_case_move(cell, move_range)
	var selected_cell = []
	for new_cell in targetcells :
		if new_cell in possiblecells :
			selected_cell.append(new_cell)
	if selected_cell == [] :
		var dif : Vector2 = (playercell - cell)
		var distance := int(abs(dif.x) + abs(dif.y))
		var directions : PoolVector2Array
		if abs(dif.x) > 0 :
			directions.append(Vector2((dif.x/abs(dif.x)), 0))
		else :
			directions.append(Vector2.LEFT)
			directions.append(Vector2.RIGHT)
		if abs(dif.y) > 0 :
			directions.append(Vector2(0,(dif.y/abs(dif.y))))
		else :
			directions.append(Vector2.UP)
			directions.append(Vector2.DOWN)
			
		if distance < 3 :
			directions[0] = -directions[0]
		selected_cell = board.remplir_case_move_direction_max(cell, move_range, directions)
		$"PathFollow2D/Sprite".modulate = Color(1, 1, 1)
	else :
		charge_rayon()
	var indice = rng.randi_range(0,len(selected_cell) - 1)
	move_along(cell,selected_cell[indice])


func move_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell
