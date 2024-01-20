#
class_name GameBoard
extends Node2D

#représente les directions que peut avoir une unitée,
const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT, Vector2.UP,Vector2.DOWN]

#on veut utiliser la grille donc on la charge à l'avance
@export var  grid : Resource = preload ("res://Scène principale/Gameboard/Grid.tres")
@export var  board : Resource = preload("res://Scène principale/Gameboard/Board.tres")
#on en bouge que un unité à la fois
#on garde  alors l'unité active dans la varialble
var _active_unit : Unit
#Array des cellules ou l'active unit peut aller/tirer/agir
#on le rempli avec les fonction _jump_player,_dash_player.....
var _selected_cells := []

var state #permet de savoir quel type d'action le robot est en train d'effectuer
 #note si le joueur tire 
@onready var _unit_path : UnitPath = $UnitPath

@onready var _unit_overlay : UnitOverlay = $UnitOverlay
@onready var _aim_overlay : UnitOverlay = $AimOverlay

#au début du jeu on réinitialise le plateau
func _ready()-> void:
	_reinitialize()
	#on setup ici la reference du joueur dans board car get_node n'est pas défini pour board (une ressource)
	board.Player = $"Player"
	#Connection des signaux d'évènements
	EventSingleton.connect("player_neutre", _on_EventSingleton_player_neutre)
	EventSingleton.connect("move_player", _on_EventSingleton_move_player)
	EventSingleton.connect("jump_player", _on_EventSingleton_jump_player)
	EventSingleton.connect("dash_player", _on_EventSingleton_dash_player)
	EventSingleton.connect("tir_tendu", _on_EventSingleton_tir_tendu)
	EventSingleton.connect("tir_courbe", _on_EventSingleton_tir_courbe)



#nettoie et reremplie board.units
func _reinitialize () -> void :
	board.units.clear()
	for child in get_children():
		var unit := child as Unit
		if not unit:
			continue
		board.units[unit.cell] = unit

	
#selectionne l'unité dans la cellule si il y en a une
#ie la met cmme avcitve_unit et dessine les cellule ateingable
func _select_unit(cell: Vector2) -> void :
	#on verifie si l'unité existe
	if not board.units.has(cell):
		return
	_active_unit = board.units[cell]
	_active_unit.is_selected = true
	if _active_unit == $"Player" :
		match state :
			"Mouvement":
				_selected_cells =  board.remplir_case_move($"Player".cell,$"Player".move_range)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(0,_selected_cells, "jaune")#on les affiche en jaune
			"Saut":
				_selected_cells = board.remplir_case_cercle($"Player".cell,$"Player".rsautext,$"Player".rsautint,false)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(0,_selected_cells, "jaune")#on les affiche en jaune
			"Charge" :
				_selected_cells = board.remplir_case_ligne($"Player".cell,$"Player".limitedash,false)
				#on rempli l'array de cellule que le joueur peut utiliser
				_unit_overlay.clear()
				_unit_overlay.draw(0,_selected_cells, "jaune")#on les affiche en jaune
			"Tir_tendu":
				_selected_cells = board.remplir_case_ligne($"Player".cell, $"Player".limitetir,true)
				#on rempli l'array de cellules que le joueur peut toucher au gun
				_unit_overlay.clear()
				_unit_overlay.draw(0,_selected_cells, "vert")#on les affiche en vert
			"Tir_courbe" :
				_selected_cells = board.remplir_case_cercle($"Player".cell, $"Player".rlimitetir,2, true)
				#on rempli l'array de cellules que le joueur peut toucher au gun
				_unit_overlay.clear()
				_unit_overlay.draw(0,_selected_cells, "vert")#on les affiche en vert

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
	if board.is_occupied(new_cell) or not(new_cell in _selected_cells):
		return
		
	var difference : Vector2 = (_active_unit.cell - new_cell).abs()		#si l'on déplace l'unité on retire les déplacement de sa portée
	var distance := int (difference.x + difference.y)
	_active_unit.move_range -= distance
	board.units.erase(_active_unit.cell) #on enleve l'unité à l'ancienne case du dictionnaire
	board.units[new_cell] = _active_unit #on l'inscrit à la nouvelle case
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	await _active_unit.walk_finished
	_clear_active_unit()

func _jump_player (new_cell : Vector2) -> void:
	if board.is_occupied(new_cell) or not(new_cell in _selected_cells) :
		return
	var old_cell = _active_unit.cell
	_deselect_active_unit()
	$"Player".jump_along(new_cell)
	_clear_active_unit()

func _dash_player (new_cell : Vector2) -> void :
	if board.is_occupied(new_cell) or not(new_cell in _selected_cells) :
		return
	var old_cell = _active_unit.cell
	_deselect_active_unit()
	$"Player".dash_along(new_cell)
	var direction = grid.calc_direction(new_cell,old_cell)
	$"Player"._push_cell(new_cell + direction,direction)
	_clear_active_unit()

func _tir_tendu_player (target_cell : Vector2) -> void:
	if target_cell in _selected_cells:
		var direction = grid.calc_direction(target_cell, $"Player".cell)
		var area = $"Player".aire_tirT(direction,target_cell)
		for cell in area :
			if board.is_occupied(cell) :
				match $"Player".munition.name:
					"Balle_simple" : 
						board.units[cell].is_hit(1)
					"Balle_lourde" :
						board.units[cell].is_hit(1)
					"Balle_paralysante" :
						board.units[cell].is_para(1)
				
		if board.is_occupied(target_cell) :
			match $"Player".munition.name:
				"Balle_simple" : 
					board.units[target_cell].is_hit(1)
				"Balle_lourde" :
					board.units[target_cell].is_hit(2)
				"Balle_paralysante" :
					board.units[target_cell].is_para(1)
		emit_signal("player_shot")



func _tir_courbe_player (target_cell : Vector2) -> void:
	if target_cell in _selected_cells:
		var direction = grid.calc_direction(target_cell, $"Player".cell)
		var area = $"Player".aire_tirC(direction,target_cell)
		for cell in area :
			if board.is_occupied(cell) :
				match $"Player".munition.name:
					"Balle_simple" : 
						pass
					"Balle_lourde" :
						board.units[cell].is_hit(1)
					"Balle_paralysante" :
						board.units[cell].is_para(1)
				
		if board.is_occupied(target_cell) :
			match $"Player".munition.name:
				"Balle_simple" : 
					board.units[target_cell].is_hit(2)
				"Balle_lourde" :
					board.units[target_cell].is_hit(2)
				"Balle_paralysante" :
					board.units[target_cell].is_para(1)
		emit_signal("player_shot")


signal player_moved (move_range_left)
signal player_jumped ()
signal player_dashed ()
signal player_shot ()

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
						_aim_overlay.draw(0,$"Player".aire_tirT(direction, new_cell), "rouge")
						_aim_overlay.draw(0,[new_cell],"rouge")
				"Tir_courbe" :
					if new_cell in _selected_cells :
						var direction = grid.calc_direction(new_cell, $"Player".cell)
						_aim_overlay.draw(0,$"Player".aire_tirC(direction,new_cell), "rouge")
						_aim_overlay.draw(0,[new_cell],"rouge")

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()

func _on_EventSingleton_move_player(valeur):
	print(valeur)
	state = "Mouvement"
	_deselect_active_unit() #on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_EventSingleton_jump_player():
	state = "Saut"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_EventSingleton_player_neutre():
	state = "Neutre"

func _on_EventSingleton_dash_player():
	state = "Charge"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_EventSingleton_tir_tendu(ammo):
	state = "Tir_tendu"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m

func _on_EventSingleton_tir_courbe(ammo):
	state = "Tir_courbe"
	_deselect_active_unit()#on efface les cases autours du joueur et
	_clear_active_unit()#on vide les case atteignable pour éviter les bugs avec la touche m


func _on_fin_de_tour_pressed():
	$"Player".end_turn()
	var enliste = get_tree().get_nodes_in_group("Enemy")#souris est une liste de toutes les souris
	var length = enliste.size()
	for index in range(length) :
		var en = enliste[index]
		if is_instance_valid(en) and not( en.is_queued_for_deletion()) :
			en.play_turn()
	$"Player".begin_turn()
	
@onready var enliste = get_tree().get_nodes_in_group("Enemy")#souris est une liste de toutes les souris
var index = 0
func _input(event):
	if event.is_action_released("ui_up") :
		if is_instance_valid(enliste[index%len(enliste)]) and not( enliste[index%len(enliste)].is_queued_for_deletion()):
			enliste[index%len(enliste)].play_turn()
		index += 1
