
## Represents a unit on the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.


## Shared resource of type Grid, used to calculate map coordinates. initialized in _ready
@export var grid: Resource
##Shared ressource of type board, used to know where are located amm the units. initialized in _ready
@export var board: Resource
## Texture representing the unit.
@export var skin: Texture2D
## Distance to which the unit can walk in cells.
@export var move_range : int = 3
@export var max_move_range : int = 3
@export var max_life : int = 7
@export var life : int
@export var movable : bool = true
## Offset to apply to the `skin` sprite in pixels.
@export var skin_offset := Vector2.ZERO
## The unit's move speed when it's moving along a path.
@export var move_speed := 600.0

## Coordinates of the current cell the cursor moved to.
@export var cell := Vector2.ZERO: set = set_cell
#facing unit direction
@export var direction := Vector2.DOWN: set = set_direction
## Toggles the "selected" animation on the unit.
var is_selected := false: set = set_is_selected

var _is_walking := false: set = _set_is_walking

@onready var _path_follow: PathFollow2D = $PathFollow2D

signal cell_reached()

func _ready() -> void:
	set_process(false)
	grid = load("res://Scène principale/Gameboard/Grid.tres")
	board = load("res://Scène principale/Gameboard/Board.tres")
	#board = load("res://Scène principale/Gameboard/Board.tres")
	self.cell = grid.calcul_grille_position(position)
	position = grid.calcul_map_position(cell)


	
	life = max_life
	update_lifebar()
func _process(delta: float) -> void:
	print("moving")
	_path_follow.progress += move_speed * delta
	if curve == null :
		curve = Curve2D.new()
	if _path_follow.progress >= curve.get_baked_length():
		self._is_walking = false
		emit_signal("cell_reached")


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PackedVector2Array) -> void:
	if path.is_empty():
		return

	curve.add_point(Vector2.ZERO)
	print(curve.point_count)
	for point in path:
		var new_dir = grid.calc_direction(point, cell)
		set_direction(new_dir)
		curve.add_point(grid.calcul_map_position(point) - position)
		self._is_walking = true
		await self.cell_reached
		self.cell = point
	_path_follow.progress = 0
	position = grid.calcul_map_position(cell)
	curve.clear_points()
	EventSingleton.emit_signal("walk_finished",self)

func jump_along(new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell

func dash_along (new_cell : Vector2) :
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell

func _push_cell (cell : Vector2, direction : Vector2)-> void:
	if not board.units.has(cell) :
		return
	var pushed_unit = board.units[cell]
	if pushed_unit.movable :
		if grid.dans_limite(cell+direction):
			var new_cell = cell + direction
			pushed_unit.pushed_along(cell, new_cell)
	else:
		pushed_unit.is_hit(1)
		self.is_hit(1)

func set_cell(value: Vector2) -> void:
	board.units.erase(cell) #on enleve l'unité à l'ancienne case du dictionnaire
	cell = grid.clamp(value)
	board.units[value] = self #on l'inscrit à la nouvelle case



func set_is_selected(value: bool) -> void:
	is_selected = value

func _set_is_walking(value: bool) -> void:
	_is_walking = value
	set_process(_is_walking)

func pushed_along(old_cell:Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell
	
func update_lifebar ():
	$'Lifebar'.update_health(life,max_life)

func is_hit (valeur : int)  -> void:
	life = max (0, life - valeur)
	update_lifebar()

func is_para (valeur : int) -> void:
	pass

func set_direction(new_dir : Vector2):
	match new_dir :
			Vector2.UP:
				$PathFollow2D/AnimatedSprite2D.play("up")
			Vector2.DOWN:
				$PathFollow2D/AnimatedSprite2D.play("down")
			Vector2.LEFT:
				$PathFollow2D/AnimatedSprite2D.play("left")
			Vector2.RIGHT:
				$PathFollow2D/AnimatedSprite2D.play("right")
	direction = new_dir
