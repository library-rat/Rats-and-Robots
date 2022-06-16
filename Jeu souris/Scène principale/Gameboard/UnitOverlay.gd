#affiche un overlay par dessus les cellules
class_name UnitOverlay
extends TileMap

#comme on a rendu le tile ma a demi transparent on a juste a remplir les cases
#et on aura un l'effet voulu

#rempli la tilemap avec les cases, permettant de voir ou une unité peut aller

func draw(cells: Array) -> void:
	clear()
	#pour chaque case on leur assigne la seule tuile la tuile 0
	for cell in cells :
		set_cellv(cell,0)
