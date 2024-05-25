class_name Furnace
extends Enemy
var loading := false
var damage = 2


func charge_rayon():
		loading = true
		$"PathFollow2D/AnimatedSprite2D".modulate = Color(0, 0, 1)
		update_threats() #met en rouge les cases cibles du rayon

func update_threats():
	board.remove_all_threats(self)
	if loading :
		var target = cell + direction
		while grid.dans_limite(target):
			board.add_threat(target,self)
			target += direction

func tire_rayon():
	loading = false
	var target = cell + direction
	while grid.dans_limite(target):
		board.remove_threat(target,self)
		if board.is_occupied(target) :
			board.units[target].is_hit(damage)
		target += direction

func play_turn ():
	var playercell = board.position_player()
	if loading :
		tire_rayon()
	var targetcells = board.remplir_case_cercle(playercell, 7,3,false)##!!!! c'est ici pour modifier la distance préférée des furnaces
	var possiblecells = board.remplir_case_move(cell, move_range)
	var selected_cell = []
	for new_cell in targetcells :
		if new_cell in possiblecells :
			selected_cell.append(new_cell)
	var tirera : bool = true
	if selected_cell == [] :
		tirera = false
		var dif : Vector2 = (playercell - cell)
		var distance := int(abs(dif.x) + abs(dif.y))
		var directions : PackedVector2Array
		if abs(dif.x) > 0 :
			directions.append(Vector2((dif.x/abs(dif.x)), 0))
		else :
			directions.append(Vector2.LEFT)
			directions.append(Vector2.RIGHT)
		if abs(dif.y) > 0 :
			directions.append(Vector2(0,(dif.y/abs(dif.y))))
		else :
			directions.append(Vector2.UP)
			directions.append(Vector2.DOWN)
			
		if distance < 3 :
			for i in range(len(directions)):
				directions[i] = -directions[i]
		selected_cell = board.remplir_case_move_direction_max(cell, move_range, directions)
		$"PathFollow2D/AnimatedSprite2D".modulate = Color(1, 1, 1)
		if selected_cell == [] :
			selected_cell.append(self.cell)

	var indice = rng.randi_range(0,len(selected_cell) - 1)
	move_along(cell,selected_cell[indice])
	if tirera :
		charge_rayon()
#fonction retournant le vecteur direction faisant face au joueur
func face_player ():
	var playercell : Vector2 = board.position_player()
	var dif : Vector2 = (playercell - cell)
	var face_dir : Vector2 = Vector2.ZERO 
	if abs(dif.x)>abs(dif.y) :
		face_dir.x = dif.x/abs(dif.x)
	else :
		if abs(dif.y)>1:
			face_dir.y = dif.y/abs(dif.y) 
	return (face_dir)

func move_along(old_cell : Vector2,new_cell:Vector2) -> void:
	position = grid.calcul_map_position(new_cell)
	self.cell = new_cell
	self.direction = face_player()
