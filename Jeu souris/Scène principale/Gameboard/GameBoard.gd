#
class_name GameBoard
extends Node2D

#représente les directions que peut avoir une unitée,
const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT, Vector2.UP,Vector2.DOWN]

#on veut utiliser la grille donc on la charge à l'avance
export var  grid : Resource = preload ("res://Scène principale/Gameboard/Grid.tres")

#on utilise un dictionnaire pour les unitées leur clefs est leur coordonnée,
#en coordonnée grille (vector 2) et le contenu une reference à l'unité
var _units := {}
#on en bouge que un unité à la fois
#on garde  alors l'unité active dans la varialble
var _active_unit : Unit
#Array des cellules ou l'active unit peut aller
#on le rempli avec la fonction _move_active_unit()
var _walkable_cells := []

var state #permet de savoir quel type d'action le robot est en train d'effectuer

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
	if unit == $"Player" and state == "Mouvement":
		return _remplir_case_move(unit.cell,unit.move_range)
	if unit == $"Player" and state == "Saut":
		return _remplir_case_saut(unit.cell,unit.rsautext,unit.rsautint)
	if unit == $"Player" and state == "Charge":
		return _remplir_case_charge(unit.cell)
	return []
	
#retourne un array des coordonnées de toutes les celllules possibles à traverser
#basé sur les coordonnée de la case centrale et la distance max
func _remplir_case_move(cell:Vector2, max_distance: int)-> Array:
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
	
func _remplir_case_saut(cell:Vector2, rayonext: int, rayonint: int) -> Array: #on récupere toute les case pour le saut
	#rayonext est la distance maximale de saut et rayonint est la distance minimale 
	var array = []#variable que l'on retournera
	var pile = [cell] #pile des cases à visiter
	while not pile.empty() :#tant que il y a des cases à visiter
		var current = pile.pop_back() #current est la case qui est visitée
		#on verifie à chaque ajout de case que
		#-on est dans la grille
		#-la case n'est pas déjà remplie
		#la cellule est à une distance inférieureou égale au rayon externe
		if not grid.dans_limite(current):
			continue
		if current in array :
			continue
		var difference : Vector2 = (current -cell).abs()
		var distance := int (difference.x + difference.y)
		if distance > rayonext :
			continue
		#si la case satisfait toutes les conditions et que elle n'est pas trop proche on l'ajoute
		#et on inspecte les voisins
		if distance >= rayonint :
			array.append(current)
		for direction in DIRECTIONS :
			var coordinates: Vector2 = current + direction
			#pour minimiser le nombre de tests on elimine les case déjà vues ici
			if is_occupied(coordinates):
				continue
			if coordinates in array :
				continue
			pile.append(coordinates)
	return( array)

func _remplir_case_charge (cell:Vector2) -> Array :
		var array = []
		for direction in DIRECTIONS :
			var current = cell + direction
			while not is_occupied(current) and grid.dans_limite(current):
				var difference : Vector2 = (current -cell).abs()
				var distance := int (difference.x + difference.y) #donne la distance entre la case de l'unité et current
				if distance > $"Player".limitedash :	#passe si l'on a dépassé la distance on passe
					current = current + direction		#on déplace quand meme la case pouréviter une boucle infinie
					continue
				array.append(current) #si tout est bon on ajoute la case
				current = current + direction #et on passe à la case suivante
		return (array)
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
		
	var difference : Vector2 = (_active_unit.cell - new_cell).abs()		#si l'on déplace l'unité on retire les déplacement de sa portée
	var distance := int (difference.x + difference.y)
	_active_unit.move_range -= distance
	_units.erase(_active_unit.cell) #on enleve l'unité à l'ancienne case du dictionnaire
	_units[new_cell] = _active_unit #on l'inscrit à la nouvelle case
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit,"walk_finished")
	print("bloup")
	_clear_active_unit()

func _jump_active_unit (new_cell : Vector2) -> void:
	if is_occupied(new_cell) or not(new_cell in _walkable_cells) :
		return
	var old_cell = _active_unit.cell
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	$"Player".jump_along(old_cell,new_cell)
	_clear_active_unit()

func _dash_active_unit (new_cell : Vector2) -> void :
	if is_occupied(new_cell) or not(new_cell in _walkable_cells) :
		return
	var old_cell = _active_unit.cell
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	$"Player".dash_along(old_cell,new_cell)
	var direction = new_cell-old_cell
	if direction.x > 0:
		direction = Vector2.RIGHT
		
	if direction.x < 0:
		direction = Vector2.LEFT

	if direction.y < 0:
		direction = Vector2.UP
		
	if direction.y > 0:
		direction = Vector2.DOWN
	_push_unit(new_cell + direction,direction)
	_clear_active_unit()


signal player_moved (move_range_left)
signal player_jumped ()
signal player_dashed ()

func _push_unit (cell : Vector2, direction : Vector2)-> void:
	if not _units.has(cell) :
		return
	var pushed_unit = _units[cell]
	if pushed_unit.movable :
		var new_cell = cell + direction
		_units.erase(pushed_unit.cell)
		pushed_unit.pushed_along(cell, new_cell)
		_units[new_cell] = pushed_unit
	else:
		pushed_unit.is_hit(1)
		$"Player".is_hit(1)

func _on_Cursor_accept_pressed(cell : Vector2)-> void:
	if not _active_unit:
		_select_unit(cell)
	elif not cell in _walkable_cells :
		_deselect_active_unit()
		_clear_active_unit()
	elif _active_unit.is_selected and (_active_unit == $Player)  :	#si l'unité est le joueur, que l'action est mouvement on peut la bouger
		if state == "Mouvement":
			_move_active_unit(cell)
			emit_signal( "player_moved", $Player.move_range)
		if state == "Saut" :
			_jump_active_unit(cell)
			emit_signal("player_jumped")
		if state == "Charge":
			_dash_active_unit(cell)
			emit_signal("player_dashed")


func _on_Cursor_moved(new_cell:Vector2)-> void:
	if _active_unit and _active_unit.is_selected :	#si une unitée selectionnée
		if _active_unit == $Player  and state == "Mouvement" :#si on a sélectionner le joueur pour le faire marcher
			_unit_path.draw(_active_unit.cell,new_cell) #on dessine le chemin

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()


func _on_AfficheactionActive_move_player(valeur):
	state = "Mouvement"


func _on_AfficheactionActive_jump_player():
	state = "Saut"


func _on_AfficheactionActive_player_neutre():
	state = "Neutre"

func _on_AfficheactionActive_dash_player():
	state = "Charge"


func _on_Player_saut_fini():
	print ("signal_sent")
