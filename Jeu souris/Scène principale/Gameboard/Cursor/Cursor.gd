class_name Cursor
extends Node2D

signal accept_pressed (cell)#emit quand quand on clique sur une case selectionnée ou cliquée
signal moved(new_cell)

@export var grid: Resource = preload ("res://Scène principale/Gameboard/Grid.tres")
var offset = Vector2.ZERO

@export var ui_cooldown := 0.1#cooldown en temps
var cell := Vector2.ZERO: set = set_cell
#set_cell à chaque fois que on modifie cell
@onready var _timer : Timer = $Timer #timer pour eviter de bouger trop vite

func _ready () -> void : 
	_timer.wait_time = ui_cooldown #réinitialise le timer
	position = grid.calcul_map_position(cell) #place le curseur au centre de la cellule

func _unhandled_input(event : InputEvent) -> void :
	if event is InputEventMouseMotion : #si on bouge la souris
		self.cell = grid.calcul_grille_position(event.position)
	elif event.is_action_pressed("left click") or event.is_action_pressed("ui_accept") :
		#si l'on clique sur la caseon emet le signal adapté
		emit_signal("accept_pressed",cell+offset)
		get_viewport().set_input_as_handled()

	#pour bouger le curseur
	var should_move := event.is_pressed()
	if event.is_echo(): #si on maintient la touche ne bouge que dès que le timer est reset
		should_move = should_move and _timer.is_stopped()
	if not should_move :
		return #si on doit pas bouger on fait rien
	#on ajuste la position du cuseur
	if event.is_action("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2.DOWN
#on trace le countour de la case
func _draw() -> void :
	var taillec = grid.taille_demie_case
	var isoRight = taillec*grid.cartesien_a_isometric(Vector2.RIGHT)
	var isoLeft =taillec* grid.cartesien_a_isometric(Vector2.LEFT)
	var isoUp = taillec*grid.cartesien_a_isometric(Vector2.UP)
	var isoDown = taillec*grid.cartesien_a_isometric(Vector2.DOWN)
	draw_line(isoLeft+isoUp, isoRight+isoUp, Color.ORANGE_RED, false)
	draw_line(isoRight+isoUp, isoRight+isoDown, Color.ORANGE_RED, false)
	draw_line(isoRight+isoDown, isoLeft + isoDown, Color.ORANGE_RED, false)
	draw_line(isoLeft + isoDown, isoLeft+isoUp, Color.ORANGE_RED, false)

#fonction appellée a chaque fois que l'on bouge la position du curseur
func set_cell(value : Vector2) -> void:
	#on verifie que on est dans la grille
	var value_cart = grid.clamp(value +offset)
	var new_cell: Vector2 = (value_cart)
	if new_cell.is_equal_approx(cell+offset):
		return #on fait rien si on peut pas bouger
	cell = new_cell
	#si on bouge on emet un signal pour le dire et on relance le timer
	position = grid.calcul_map_position(cell) -grid.cartesien_a_isometric(offset* grid.taille_case)
	emit_signal("moved", cell+offset)
	_timer.start()

