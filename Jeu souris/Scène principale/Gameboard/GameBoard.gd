#
class_name GameBoard
extends Node2D

#représente les directions que peut avoir une unitée,
const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT, Vector2.UP,Vector2.DOWN]

#on veut utiliser la grille donc on la charge à l'avance
export var  grid : Resource = preload ("res://Scène principale/Gameboard/Grid.tres")

#on utilise un dictionnaire pour les unitées leur clefs est leur coordonnée,
#en coordonnée grille et le contenu une reference à l'unité
var _units := {}
#on en bouge que un unité à la fois
#on garde  alors l'unité active dans la varialble
var _active_unit : Unit
#Array des cellules ou l'active unit peut aller
#on le rempli avec la fonction _move_active_unit()
var _walkable_cells := []

onready var _unit_path : UnitPath = $UnitPath

onready var _unit_overlay : UnitOverlay = $UnitOverlay

#au début du jeu on réinitialise le plateau
func _ready()-> void:
	_reinitialize()

#renvoie vrai si la case est occupée par une unitée
func is_occupied(cell : Vector2) -> bool :
	return true if _units.has(cell) else false

#nettoie et reremplie _units
func _reinitialize () -> void :
	_units.clear()
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		_units[unit.cell] = unit

	
#retourne un array de cellule que une unité peut utiliser
func get_walkable_cells (unit: Unit) -> Array:
	return _flood_fill(unit.cell,unit.move_range)
	
#retourne un array des coordonnées de toutes les celllules possibles à traverser
#basé sur les coordonnée de la case centrale et la distance max
func _flood_fill(cell:Vector2, max_distance: int)-> Array:
	#variable que l'on retournera
	var array :=  []
	#on utilise une pile pour implémenter l'algo
	var stack := [cell]
	while not stack.empty():
		var current = stack.pop_back()
		#on verifie à chaque ajout de case que
		#-on est dans la grille
		#-la case n'est pas déjà remplie
		#la cellule est à une distance inférieure à la distance max
		if not grid.dans_limite(current):
			continue
		if current in array :
			continue
		var difference : Vector2 = (current -cell).abs()
		var distance := int (difference.x + difference.y)
		if distance > max_distance :
			continue
		#si la case satisfait toutes les conditions on l'ajoute à array
		#et on inspecte les voisins
		array.append(current)
		for direction in DIRECTIONS :
			var coordinates: Vector2 = current + direction
			#pour minimiser le nombre de tests on elimine les case déjà vues ici
			if is_occupied(coordinates):
				continue
			if coordinates in array :
				continue
			stack.append(coordinates)
	return( array)
	
#selectionne l'unité dans la cellule si il y en a une
#ie la met cmme avcitve_unit et dessine les cellule ateingable
func _select_unit(cell: Vector2) -> void :
	#on verifie si l'unité existe
	if not _units.has(cell):
		return
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)

func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()


func _move_active_unit(new_cell : Vector2) -> void :
	if is_occupied(new_cell) or not(new_cell in _walkable_cells):
		return
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit,"walk_finished")
	
	_clear_active_unit()


func _on_Cursor_accept_pressed(cell : Vector2)-> void:
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)


func _on_Cursor_moved(new_cell:Vector2)-> void:
	
	print(_active_unit)
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell,new_cell)

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()
