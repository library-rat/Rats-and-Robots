class_name Grid
extends Resource

export var taille := Vector2(200,200)# talle de la grille en ligne, colonnes
export var taille_case:= Vector2(32,32)#taille d'une case en pixels

var taille_demie_case = taille_case/2

func calcul_map_position(position_grille: Vector2) ->Vector2:
		return cartesien_a_isometric(position_grille* taille_case + taille_demie_case)
#reçoit la position dans la grille et retourne la position de l'unité sur la map (interface graphique)

func calcul_grille_position(position_map:Vector2) -> Vector2:
		return (isometric_a_cartesien(position_map)/taille_case).floor()
#permet la conversion inverse de la fonction précédente de l'interface graphique à la grille


func cartesien_a_isometric (cartesien:Vector2)-> Vector2: 
		return (Vector2(cartesien.x -cartesien.y,(cartesien.x+cartesien.y)/2))
	
func isometric_a_cartesien (isometric:Vector2) -> Vector2 :
	return (Vector2( (isometric.x + 2*isometric.y)/2,(-isometric.x + 2*isometric.y)/2))

func dans_limite(coordonnees_case: Vector2) -> bool :
	if coordonnees_case.x >= 0 and coordonnees_case.x < taille.x :
		if coordonnees_case.y >= 0 and coordonnees_case.y< taille.y:
			return (true)
	return(false)
#revoie si un case des dans les limites de la grille ou pas

func calc_direction (new_cell : Vector2,old_cell:Vector2) -> Vector2 :
	var direction = new_cell-old_cell
	if direction.x > 0:
		direction = Vector2.RIGHT
		
	if direction.x < 0:
		direction = Vector2.LEFT

	if direction.y < 0:
		direction = Vector2.UP
		
	if direction.y > 0:
		direction = Vector2.DOWN
	return(direction)

func clamp(grille_position: Vector2) -> Vector2 :
	var out := grille_position
	out.x = clamp(out.x,0, taille.x - 1.0)
	out.y = clamp(out.y,0, taille.y - 1.0)
	return(out)

func as_index(case : Vector2) -> int :
	return int(case.x +taille.x*case.y)

