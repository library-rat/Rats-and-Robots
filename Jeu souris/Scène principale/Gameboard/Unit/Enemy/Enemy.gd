tool
class_name Enemy
extends "res://Scène principale/Gameboard/Unit/Unit.gd"

export var para = 0 setget para_var_set
var frozen : bool = false 

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

