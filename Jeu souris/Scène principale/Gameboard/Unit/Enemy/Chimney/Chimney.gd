tool
class_name Chimney
extends "res://Scène principale/Gameboard/Unit/Enemy/Enemy.gd"
var loading := false
var damage = 1
var reach = 10

var TargetArea = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT, Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1),Vector2.ZERO]

func _ready():
	board.connect("player_moved", self, "update_threat")

func update_threats():
	print("boum")
	var playercell = board.position_player()
	board.remove_all_threats(self)
	if loading and player_alone() :
		for direction in TargetArea :
			var target = direction + playercell
			if is_in_reach(target):
				board.add_threat(target,self)
	
func tire_boulet(target):
	var playercell = board.position_player()
	for direction in TargetArea :
		if board.is_occupied(target+direction) and is_in_reach(target):
			board.units[target+direction].is_hit(damage)
			

func is_in_reach(target_cell: Vector2):
	var dif : Vector2 = ( target_cell - cell)
	var distance := int(abs(dif.x) + abs(dif.y))
	return ((grid.dans_limite(target_cell))and(distance <= reach))

func play_turn ():
	var playercell = board.position_player()
	if loading and player_alone():
		tire_boulet(playercell)
	#var possiblecells = board.remplir_case_move(cell, move_range)
	loading = true

func player_alone() -> bool :
	var playercell = board.position_player()
	for direction in TargetArea :
		if board.is_occupied(direction + playercell):
			if board.units[direction+ playercell].is_in_group("Enemy"):
				return(false)
	return true
