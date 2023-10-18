class_name Enemy
extends Unit
@export var para = 0: set = para_var_set
var frozen : bool = false 
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func para_var_set(new_val):
	if new_val > 0:
		para = new_val
	else:
		para = 0

func update_lifebar ():
	$'Lifebar'.update_health(life,max_life,para)

func is_hit (valeur : int)  -> void:
	if life < valeur :
		self.para -= valeur - life #self. permet d'activer la fonction para_var_set
		life = 0
		if para > 0 :
			frozen = true
		else :
			frozen = false
	else :
		life -= valeur
	update_lifebar()
	if life == 0 and para == 0:
		dying()


func dying():
	board.remove_enemy(self)
	self.queue_free()


func is_para(valeur : int) ->void:
	if valeur > life :
		valeur = life
	para += valeur
	life -= valeur
	update_lifebar()

func set_cell(value: Vector2) -> void: #version de set_cell, override the one from Unit
	board.units.erase(cell) #on enleve l'unité à l'ancienne case du dictionnaire
	cell = grid.clamp(value)
	board.units[value] = self #on l'inscrit à la nouvelle case
	update_threats()
	
func update_threats():#function  supposed to be override by each kind of ennemy
	board.remove_all_threats(self)

