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
#Array des cellules ou l'active unit peut aller/tirer/agir
#on le rempli avec les fonction _jump_player,_dash_player.....
var _selected_cells := []

var state #permet de savoir quel type d'action le robot est en train d'effectuer
 #note si le joueur tire 
onready var _unit_path : UnitPath = $UnitPath

onready var _unit_overlay : UnitOverlay = $UnitOverlay
onready var _aim_overlay : UnitOverlay = $AimOverlay

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

	
#retourne un array des coordonnées de toutes les celllules possibles à traverser
#basé sur les coordonnée de la case centrale et la distance max
func _remplir_case_move(cell:Vector2, max_distance: int)-> Array:
	#variable que l'on retournera
	var array :=  []
	#on utilise une file pour implémenter l'algo
	var queue := [{"cell":cell,"dist":0}]
	while not queue.empty():
		var current = queue.pop_front()
		var curcell = current["cell"]
		#on verifie à chaque ajout de case que
		#-on est dans la grille
		#-la case n'est pas déjà remplie
		#la cellule est à une distance inférieure à la distance max
		if not grid.dans_limite(curcell):
			continue
		if curcell in array :
			continue
		if current["dist"] > max_distance :
			continue
		#si la case satisfait toutes les conditions on l'ajoute à array
		#et on inspecte les voisins
		array.append(curcell)
		for direction in DIRECTIONS :
			var coordinates: Vector2 = curcell + direction
			#pour minimiser le nombre de tests on elimine les case déjà vues ici
			if is_occupied(coordinates):
				continue
			if coordinates in array :
				continue
			var newdist = current["dist"] +1
			queue.append({"cell":coordinates, "dist":newdist})
	return( array)
	
#retourne toute les case pour le saut
#rayonext est la distance maximale de saut et rayonint est la distance minimale 
#select_occu dit si l'on selectionne les cases occupées ou pas
func _remplir_case_cercle(cell:Vector2, rayonext: int, rayonint: int, select_occu : bool) -> Array:
	var dejavu =[]
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
		if current in dejavu :
			continue
		dejavu.append(current)
		var difference : Vector2 = (current -cell).abs()
		var distance := int (difference.x + difference.y)
		if distance > rayonext :
			continue
		#si la case satisfait toutes les conditions et que elle n'est pas trop proche on l'ajoute
		#et on inspecte les voisins
		for direction in DIRECTIONS :
			var coordinates: Vector2 = current + direction
			if coordinates in array :
				continue
			pile.append(coordinates)
		if not(select_occu) and is_occupied(current) :
			continue
		if distance >= rayonint :
			array.append(current)
	return( array)
#retourne les cases ateignables pour la charge
func _remplir_case_ligne (cell:Vector2, reach:int, select_occu: bool) -> Array :
		var array = []
		for direction in DIRECTIONS :
			var current = cell + direction
			while grid.dans_limite(current):
				if is_occupied(current) :
					if select_occu :
						array.append(current)
					break
				var difference : Vector2 = (current -cell).abs()
				var distance := int (difference.x + difference.y) #donne la distance entre la case de l'unité et current
				if distance >  reach:	#passe si l'on a dépassé la distance on passe
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
	if _active_unit == $"Player" :
		match state :
			"Mouvement":
				_selected_cells =  _remplir_case_move($"Player".cell,$"Player".move_range)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(_selected_cells, "jaune")#on les affiche en jaune
			"Saut":
				_selected_cells = _remplir_case_cercle($"Player".cell,$"Player".rsautext,$"Player".rsautint,false)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(_selected_cells, "jaune")#on les affiche en jaune
			"Charge" :
				_selected_cells = _remplir_case_ligne($"Player".cell,$"Player".limitedash,false)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(_selected_cells, "jaune")#on les affiche en jaune
			"Tir_tendu":
				_selected_cells = _remplir_case_ligne($"Player".cell, $"Player".limitetir,true)
				#on rempli l'array de cellules que le joueur peut toucher au gun
				_unit_overlay.clear()
				_unit_overlay.draw(_selected_cells, "vert")#on les affiche en vert
			"Tir_courbe" :
				_selected_cells = _remplir_case_cercle($"Player".cell, $"Player".rlimitetir,2, true)
				#on rempli l'array de cellules que le joueur peut toucher au gun
				_unit_overlay.clear()
				_unit_overlay.draw(_selected_cells, "vert")#on les affiche en vert

	_unit_path.initialize(_selected_cells)

func _deselect_active_unit() -> void:
	if _active_unit != null :
		_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	
func _clear_active_unit() -> void:
	_active_unit = null
	_selected_cells.clear()


func _move_active_unit(new_cell : Vector2) -> void :
	if is_occupied(new_cell) or not(new_cell in _selected_cells):
		return
		
	var difference : Vector2 = (_active_unit.cell - new_cell).abs()		#si l'on déplace l'unité on retire les déplacement de sa portée
	var distance := int (difference.x + difference.y)
	_active_unit.move_range -= distance
	_units.erase(_active_unit.cell) #on enleve l'unité à l'ancienne case du dictionnaire
	_units[new_cell] = _active_unit #on l'inscrit à la nouvelle case
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit,"walk_finished")
	_clear_active_unit()

func _jump_player (new_cell : Vector2) -> void:
	if is_occupied(new_cell) or not(new_cell in _selected_cells) :
		return
	var old_cell = _active_unit.cell
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	$"Player".jump_along(old_cell,new_cell)
	_clear_active_unit()

func _dash_player (new_cell : Vector2) -> void :
	if is_occupied(new_cell) or not(new_cell in _selected_cells) :
		return
	var old_cell = _active_unit.cell
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	$"Player".dash_along(old_cell,new_cell)
	var direction = grid.calc_direction(new_cell,old_cell)
	_push_unit(new_cell + direction,direction)
	_clear_active_unit()

func _tir_tendu_player (target_cell : Vector2) -> void:
	if target_cell in _selected_cells:
		var direction = grid.calc_direction(target_cell, $"Player".cell)
		var area = $"Player".aire_tirT(direction,target_cell)
		for cell in area :
			if is_occupied(cell) :
				match $"Player".munition.name:
					"Balle_simple" : 
						_units[cell].is_hit(1)
					"Balle_lourde" :
						_units[cell].is_hit(1)
				
		if is_occupied(target_cell) :
			match $"Player".munition.name:
				"Balle_simple" : 
					_units[target_cell].is_hit(1)
				"Balle_lourde" :
					_units[target_cell].is_hit(2)
		emit_signal("player_shot")



func _tir_courbe_player (target_cell : Vector2) -> void:
	if target_cell in _selected_cells:
		var direction = grid.calc_direction(target_cell, $"Player".cell)
		var area = $"Player".aire_tirC(direction,target_cell)
		for cell in area :
			if is_occupied(cell) :
				match $"Player".munition.name:
					"Balle_simple" : 
						pass
					"Balle_lourde" :
						_units[cell].is_hit(1)
				
		if is_occupied(target_cell) :
			match $"Player".munition.name:
				"Balle_simple" : 
					_units[target_cell].is_hit(2)
				"Balle_lourde" :
					_units[target_cell].is_hit(2)
		emit_signal("player_shot")


signal player_moved (move_range_left)
signal player_jumped ()
signal player_dashed ()
signal player_shot ()

func _push_unit (cell : Vector2, direction : Vector2)-> void:
	if not _units.has(cell) :
		return
	var pushed_unit = _units[cell]
	if pushed_unit.movable :
		if grid.dans_limite(cell+direction):
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
	elif not cell in _selected_cells :
		_deselect_active_unit()
		_clear_active_unit()
	elif _active_unit.is_selected and (_active_unit == $Player)  :	#si l'unité est le joueur, que l'action est mouvement on peut la bouger
		if state == "Mouvement":
			_move_active_unit(cell)
			emit_signal( "player_moved", $Player.move_range)
		if state == "Saut" :
			_jump_player(cell)
			emit_signal("player_jumped")
		if state == "Charge":
			_dash_player(cell)
			emit_signal("player_dashed")
		if state =="Tir_tendu":
			_tir_tendu_player(cell)
		if state == "Tir_courbe":
			_tir_courbe_player(cell)

func _on_Cursor_moved(new_cell:Vector2)-> void:
	if _active_unit and _active_unit.is_selected :	#si une unitée selectionnée
		if _active_unit == $Player  :
			_aim_overlay.clear()
			match state :
				"Mouvement" :#si on a sélectionner le joueur pour le faire marcher
					_unit_path.draw($"Player".cell,new_cell) #on dessine le chemin
				"Tir_tendu":
					if new_cell in _selected_cells :
						var direction = grid.calc_direction(new_cell, $"Player".cell)
						_aim_overlay.draw($"Player".aire_tirT(direction, new_cell), "rouge")
						_aim_overlay.draw([new_cell],"rouge")
				"Tir_courbe" :
					if new_cell in _selected_cells :
						var direction = grid.calc_direction(new_cell, $"Player".cell)
						_aim_overlay.draw($"Player".aire_tirC(direction,new_cell), "rouge")
						_aim_overlay.draw([new_cell],"rouge")

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()

func _on_AfficheactionActive_move_player(valeur):
	state = "Mouvement"
	_deselect_active_unit() #on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_AfficheactionActive_jump_player():
	state = "Saut"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_AfficheactionActive_player_neutre():
	state = "Neutre"

func _on_AfficheactionActive_dash_player():
	state = "Charge"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_AfficheactionActive_tir_tendu(ammo):
	state = "Tir_tendu"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_AfficheactionActive_tir_courbe(ammo):
	state = "Tir_courbe"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m
