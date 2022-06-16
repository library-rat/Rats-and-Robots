extends HBoxContainer

var lifebarfull = preload ("res://Scène principale/Gameboard/Unit/Lifebar/FIll_lifesegment.png")#on charge les ressources
var lifebarempty = preload("res://Scène principale/Gameboard/Unit/Lifebar/Empty_lifesegment.png")

func update_health(life,maxlife) :

	for n in self.get_children(): #on doit d'abord retirer tour les nœuds fils
		self.remove_child(n)
		n.queue_free()
			
	for i in range(life) :
		var fullbit = TextureRect.new()
		fullbit.texture = lifebarfull #on créé le noeuds pour un pixel de vie plein
		#fullbit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		fullbit.expand = true
		fullbit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		add_child(fullbit)#et on l'ajoute
	for i in range(maxlife - life):
		var emptybit = TextureRect.new()
		emptybit.texture = lifebarempty #on créé le noeuds pour un pixel de vie vide
		#emptybit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		emptybit.expand = true
		emptybit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		add_child(emptybit)#et on l'ajoute
