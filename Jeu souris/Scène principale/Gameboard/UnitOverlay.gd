#affiche un overlay par dessus les cellules
class_name UnitOverlay
extends TileMap

#comme on a rendu le tile ma a demi transparent on a juste a remplir les cases
#et on aura un l'effet voulu

#rempli la tilemap avec les cases, permettant de voir ou une unité peut aller

func draw(layer : int, cells: Array, color: String) -> void:
	#pour chaque case on leur assigne la seule tuile la tuile 0
	print(cells);
	var number = 1
	match color :
		"jaune" :
			number = 1
		"vert":
			number = 2
		"rouge":
			number = 3
	for cell in cells :
		set_cell(layer,cell,number)
