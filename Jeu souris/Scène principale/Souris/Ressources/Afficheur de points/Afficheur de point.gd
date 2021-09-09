extends CenterContainer

func affiche_point (pt) :
	if pt is Point :
		$PointTextureRect.texture = pt.texture
