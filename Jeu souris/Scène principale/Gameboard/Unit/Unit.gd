## Represents a unit on the game board.
## The board manages its position inside the game grid.
## The unit itself holds stats and a visual representation that moves smoothly in the game world.
tool
class_name Unit
extends Path2D

## Emitted when the unit reached the end of a path along which it was walking.
signal walk_finished

## Shared resource of type Grid, used to calculate map coordinates.
export var grid: Resource
##Shared ressource of type board, used to know where are located amm the units
export var board: Resource
## Texture representing the unit.
export var skin: Texture setget set_skin
## Distance to which the unit can walk in cells.
export var move_range : int = 3
export var max_move_range : int = 3
export var max_life : int = 7
export var life : int
export var movable : bool = true
## Offset to apply to the `skin` sprite in pixels.
export var skin_offset := Vector2.ZERO setget set_skin_offset
## The unit's move speed when it's moving along a path.
export var move_speed := 600.0

## Coordinates of the current cell the cursor moved to.
export var cell := Vector2.ZERO setget set_cell
#facing unit direction
export var direction := Vector2.DOWN
## Toggles the "selected" animation on the unit.
var is_selected := false setget set_is_selected

var _is_walking := false setget _set_is_walking

onready var _sprite: Sprite = $PathFollow2D/Sprite
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _path_follow: PathFollow2D = $PathFollow2D


func _ready() -> void:
	set_process(false)
	grid = load("res://Scène principale/Gameboard/Grid.tres")
	board = load("res://Scène principale/Gameboard/Board.tres")
	self.cell = grid.calcul_grille_position(position)
	position = grid.calcul_map_position(cell)

	# We create the curve resource here because creating it in the editor prevents us from
	# moving the unit.
	if not Engine.editor_hint:
		curve = Curve2D.new()
	
	life = max_life
	update_lifebar()
func _process(delta: float) -> void:
	_path_follow.offset += move_speed * delta

	if _path_follow.offset >= curve.get_baked_length():
		self._is_walking = false
		_path_follow.offset = 0
		position = grid.calcul_map_position(cell)
		curve.clear_points()
		emit_signal("walk_finished")


## Starts walking along the `path`.
## `path` is an array of grid coordinates that the function converts to map coordinates.
func walk_along(path: PoolVector2Array) -> void:
	if path.empty():
		return

	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calcul_map_position(point) - position)
	cell = path[-1]
	self._is_walking = true


func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)


func set_is_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		_anim_player.play("selectionné")
	else:
		_anim_player.play("idle")


func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		yield(self, "ready")
	_sprite.texture = value


func set_skin_offset(value: Vector2) -> void:
	skin_offset = value
	if not _sprite:
		yield(self, "ready")
	_sprite.position = value


func _set_is_walking(value: bool) -> void:
	_is_walking = value
	set_process(_is_walking)

func pushed_along(old_cell:Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	cell = new_cell
	
func update_lifebar ():
	$'Lifebar'.update_health(life,max_life)

func is_hit (valeur : int)  -> void:
	life = max (0, life - valeur)
	update_lifebar()

func is_para (valeur : int) -> void:
	pass
