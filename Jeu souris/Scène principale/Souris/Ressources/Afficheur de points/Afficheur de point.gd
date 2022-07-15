extends CenterContainer

func affiche_point (objet) :
	if objet is Point :
		$PointTextureRect.texture = objet.texture
	if objet == null :
		$PointTextureRect.texture = null
