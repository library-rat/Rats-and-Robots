extends Resource
class_name Board

const DIRECTIONS = [Vector2.LEFT,Vector2.RIGHT, Vector2.UP,Vector2.DOWN]

#on utilise un dictionnaire pour les unitées leur clefs est leur coordonnée,
#en coordonnée grille (vector 2) et le contenu une reference à l'unité
@export var units := {}
#cette fois le dictionnaire stocke la liste de unitées attaquant une case,
#la clef la coordonnée grille de la case (vector 2) et le contenu une liste des references à l'unitée
@export var threat := {}: set = _set_threat
signal update_threat()
#variable stockant la reference du joueur elle est initialisée dans gameboard
var Player
signal player_moved()
@export var  grid : Resource = preload ("res://Scène principale/Gameboard/Grid.tres")

#retourne un array des coordonnées de toutes les celllules possibles à traverser
#basé sur les coordonnée de la case centrale et la distance max
func remplir_case_move(cell:Vector2, max_distance: int)-> Array:
	#variable que l'on retournera
	var array :=  []
	#on utilise une file pour implémenter l'algo
	var queue := [{"cell":cell,"dist":0}]
	while not queue.is_empty():
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
	
#retourne un array des coordonnées de toute les cellules à la plus grande distance traversable
#en ne se déplaçant que selon les directions "directions" et en allant moins loins que distance max
#basé sur les coordonnée de la case centrale et la distance max
func remplir_case_move_direction_max(cell:Vector2, max_distance: int, directions : PackedVector2Array)-> Array:
	#variable que l'on retournera
	var array :=  []
	var maxdist := 0
	#on utilise une file pour implémenter l'algo
	var queue := [{"cell":cell,"dist":0}]
	while not queue.is_empty():
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
		#si la cellule est plus loin que toute les autres on vide la liste des candidats
		if current["dist"] > maxdist :
			array = []
			maxdist = current["dist"]
		#si la case satisfait toutes les conditions on l'ajoute à array
		#et on inspecte les voisins
		array.append(curcell)
		for direction in directions :
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
func remplir_case_cercle(cell:Vector2, rayonext: int, rayonint: int, select_occu : bool) -> Array:
	var dejavu =[]
	var array = []#variable que l'on retournera
	var pile = [cell] #pile des cases à visiter
	while not pile.is_empty() :#tant que il y a des cases à visiter
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
func remplir_case_ligne (cell:Vector2, reach:int, select_occu: bool) -> Array :
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

#renvoie vrai si la case est occupée par une unitée
func is_occupied(cell : Vector2) -> bool :
	return true if units.has(cell) else false

func remove_enemy(unit:Enemy) -> void :
	var key_array = units.keys() 
	for key in key_array :
		if units[key] == unit :
			units.erase(key)
	remove_all_threats(unit)

func remove_all_threats(unit:Enemy):
	var cell_array = threat.keys()
	for cell in cell_array :
		remove_threat(cell,unit)

	
func add_threat(cell : Vector2, unit : Enemy) -> void: 
	if threat.has(cell) :
		threat[cell].append(unit)
	else :
		self.threat[cell] = [unit]
	emit_signal("update_threat")

func remove_threat(cell : Vector2, unit : Enemy) -> void: 
	if cell in threat :
		self.threat[cell].erase(unit)
		if threat[cell] == [] :
			self.threat.erase(cell)
		emit_signal("update_threat")

func _set_threat(new_dic):
	threat = new_dic
	emit_signal("update_threat")

	
func is_danger(cell : Vector2) -> bool:
	return true if threat.has(cell) else false

func _emit_player_moved():
	emit_signal("player_moved")

func position_player():
	if not Player == null:
		return(Player.cell)
