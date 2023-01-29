extends HBoxContainer

var lifebarfull = preload ("res://Scène principale/Gameboard/Unit/Lifebar/FIll_lifesegment.png")#on charge les ressources
var lifebarempty = preload("res://Scène principale/Gameboard/Unit/Lifebar/Empty_lifesegment.png")
var lifebarpara = preload ("res://Scène principale/Gameboard/Unit/Lifebar/Para_lifesegment.png")
var lifebararmor = preload("res://Scène principale/Gameboard/Unit/Lifebar/Armor_lifesegment.png")

func update_health(life,maxlife, para = 0) :
	for n in self.get_children(): #on doit d'abord retirer tour les nœuds fils
		self.remove_child(n)
		n.queue_free()
			
	for i in range(life) :
		var fullbit = TextureRect.new()
		fullbit.texture = lifebarfull #on créé le noeuds pour un pixel de vie plein
		#fullbit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		fullbit.expand = true
		fullbit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		fullbit.mouse_filter = MOUSE_FILTER_IGNORE #on fait en sorte que il ne bloque pas les clicks
		add_child(fullbit)#et on l'ajoute
		
	for i in range (para) :
		var parabit = TextureRect.new()
		parabit.texture = lifebarpara #on créé le noeuds pour un pixel de vie paralysé
		#parabit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		parabit.expand = true
		parabit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		parabit.mouse_filter = MOUSE_FILTER_IGNORE #on fait en sorte que il ne bloque pas les clicks
		add_child(parabit)#et on l'ajoute

		
	for i in range(maxlife - life -para):
		var emptybit = TextureRect.new()
		emptybit.texture = lifebarempty #on créé le noeuds pour un pixel de vie vide
		#emptybit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		emptybit.expand = true
		emptybit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		emptybit.mouse_filter = MOUSE_FILTER_IGNORE #on fait en sorte que il ne bloque pas les clicks
		add_child(emptybit)#et on l'ajoute

func add_armor(armure = 0):
	for i in range(armure):
		var emptybit = TextureRect.new()
		emptybit.texture = lifebararmor #on créé le noeuds pour un pixel de vie vide
		#emptybit.stretch_mode =TextureRect.STRETCH_KEEP_ASPECT
		emptybit.expand = true
		emptybit.size_flags_horizontal = TextureRect.SIZE_EXPAND_FILL#on fait en sorte que il prenne la bonne place
		emptybit.mouse_filter = MOUSE_FILTER_IGNORE #on fait en sorte que il ne bloque pas les clicks
		add_child(emptybit)#et on l'ajoute
