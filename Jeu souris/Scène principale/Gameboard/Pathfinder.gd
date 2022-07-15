#Utilise l'algo Astar
class_name PathFinder
extends Reference

const DIRECTIONS = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]
#Liste des directions possibles pour une unitée on en aura besoin dans une boucle for après

var _grid : Resource

var _astar := AStar2D.new()
#l'instance Astar qui va chercher le chemin

#Initializes l'Astar dès le lancement
func _init(grid : Grid,walkable_cells : Array) -> void :
	#on va l'instancier depuis UnitPath.gd donc on lui 
	#donnera les informations dont il a besoin
	_grid = grid
	#pour le AStar on aura besoin on aura besoin de l'index de chaque case
	#ici on cache le lien entre les coordonnées des cellules et leur index (mieux en terme de performances
	var cell_mappings := {}
	for cell in walkable_cells :
	#Pour chaques cases on definit une clef identificative l'index
		cell_mappings[cell] = grid.as_index(cell)
#On ajoute alors toutes les cases dans l'instance Astar
	_add_and_connect_points(cell_mappings)

func calculate_point_path( start : Vector2, end : Vector2) -> PoolVector2Array :
	#Pour l'algo Astar on a besoin des indices pour faire le chemin
	#On a donc besoin de pouvoir trouver l'index avec les coordonnées ce que fait grad.as_index()
	var start_index : int = _grid.as_index(start)
	var end_index : int = _grid.as_index(end)
	#si le chemin est defini on le retourn sinon on retourne un chemin vide
	if _astar.has_point(start_index) and _astar.has_point(end_index):
		return _astar.get_point_path(start_index,end_index)
	else :
		return PoolVector2Array()

#Ajoute et connecte les cases ou l'on peut marcher à l'instace AStar
func _add_and_connect_points(cell_mappings : Dictionary ) -> void :
	#fonction en deux temps d'abord on enregistre tout les points de l'AStar graph
	#on passe l'index et les coordonnées à AStar2D.add_point() function.
	for point in cell_mappings :
		_astar.add_point(cell_mappings[point],point)
	#Puis après on boucle pour chaque points et on les connectent à leurs voisins
	#On utilisera _find_neighbor_indices pour trouver les voisins
	for point in cell_mappings :
		for neighbor_index in _find_neighbor_indices(point,cell_mappings):
			#attention Astar2D.connect_points() prends des index en entrée
			_astar.connect_points(cell_mappings[point], neighbor_index)
	
func _find_neighbor_indices(cell: Vector2, cell_mappings : Dictionary) -> Array:
	var out := []
	#pour trouver les voisins on test toutes les cases adjacentes et on prends
	#celles qui ne sont pas déjà connectées ou qui sont unwalkable
	for direction in DIRECTIONS:
		var neighbor : Vector2 = cell + direction
		if not cell_mappings.has(neighbor):
			continue #son passe à l'itération suivante si le voisin c'est pas dans les cases
		if not _astar.are_points_connected(cell_mappings[cell],cell_mappings[neighbor]):
		#evite de connecter un point déjà connecté
			out.push_back(cell_mappings[neighbor])
	return out
