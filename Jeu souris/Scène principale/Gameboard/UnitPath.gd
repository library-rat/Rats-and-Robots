#On l'autotile pour faire le chamin de l'unitée 
class_name UnitPath
extends TileMap

export var grid: Resource

#on créer un nouvel object pathFinder à chaque selection d'unitée
var _pathfinder: PathFinder
# Stoque le chemin de l'unité
#si le chemin est validé par le joueur on fait bouger le personnage à l'aide de 
# la fonction walk_along().
var current_path := PoolVector2Array()

# Creates a new PathFinder that uses the AStar algorithm we use to find a path between two cells 
# among the `walkable_cells`.
# We'll call this function every time the player selects a unit (in the gameboard script)
func initialize(walkable_cells: Array) -> void:
	_pathfinder = PathFinder.new(grid, walkable_cells)


# Finds and draws the path between `cell_start` and `cell_end`.
func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	# We first clear any tiles on the tilemap, then let the Astar2D (PathFinder) find the
	# path for us.
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	print (current_path)
	# And we draw a tile for every cell in the path.
	for cell in current_path:
		set_cellv(cell, 0)
	# The function below updates the auto-tiling. Without it, you wouldn't get the nice path with curves
	# and the arrows on either end.
	update_bitmask_region()


# Stops drawing, clearing the drawn path and the `_pathfinder`.
func stop() -> void:
	_pathfinder = null
	clear()
