@tool
class_name Chimney
extends Enemy
var loading := false
var damage = 1
var reach = 10

var TargetArea = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT, Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1),Vector2.ZERO]

func _ready():
	board.connect("player_moved", Callable(self, "_on_player_moved"))

func _on_player_moved():
	update_threats()

func update_threats():
	var playercell = board.position_player()
	if playercell == null :
		return
	board.remove_all_threats(self)
	
	for direction in TargetArea :
		if board.is_occupied(direction + playercell):
			if board.units[direction+ playercell].is_in_group("Enemy"):
				loading = false
	
	if loading and player_in_reach() :
		for direction in TargetArea :
			var target = direction + playercell
			if grid.dans_limite(target):
				board.add_threat(target,self)
	
func tire_boulet(target):
	var playercell = board.position_player()
	for direction in TargetArea :
		if board.is_occupied(target+direction):
			board.units[target+direction].is_hit(damage)
			

func play_turn ():
	var playercell = board.position_player()
	if loading and player_in_reach():
		tire_boulet(playercell)
	var dif : Vector2 = (playercell - cell)
	var distance := int(abs(dif.x) + abs(dif.y))
	if distance < 4  or board.is_danger(cell) :
		var possiblecells = board.remplir_case_move(cell, move_range)
		var best_cell : PackedVector2Array = []
		var worst_cell : PackedVector2Array = []
		for new_cell in possiblecells :
			if  not(board.is_occupied(new_cell)):
				var new_dif : Vector2 = playercell - new_cell
				var new_dist : int = abs(new_dif.x) + abs(new_dif.y)
				if not(board.is_danger(new_cell)) and (new_dist < 10 and new_dist > 5):
					best_cell.append(new_cell)
				elif new_dist > distance :
					worst_cell.append(new_cell)
		
		if not (best_cell.is_empty()) :
			var indice = rng.randi_range(0,len(best_cell) - 1)
			move_along(cell,best_cell[indice])
		elif not(worst_cell.is_empty()) :
			var indice = rng.randi_range(0,len(worst_cell) - 1)
			move_along(cell,worst_cell[indice])
			
	loading = true
	update_threats()

func move_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell

func player_in_reach() -> bool :
	var playercell = board.position_player()
	
	var dif : Vector2 = ( playercell - cell)
	var distance := int(abs(dif.x) + abs(dif.y))
	
	if distance > reach:
		return false
	
	for direction in TargetArea :
		if board.is_occupied(direction + playercell):
			if board.units[direction+ playercell].is_in_group("Enemy"):
				return(false)
	return true
