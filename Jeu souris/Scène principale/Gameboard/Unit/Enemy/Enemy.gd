tool
class_name Enemy
extends "res://Scène principale/Gameboard/Unit/Unit.gd"
export var para = 0


func _ready():
	self.add_to_group('Enemy')

func update_lifebar ():
	$'Lifebar'.update_health(life,max_life,para)

func is_hit (valeur : int)  -> void:
	if life < valeur :
		para -= valeur - life
		life = 0
	else :
		life -= valeur
	print (life)
	print(max_life)
	print(para)
	update_lifebar()

func is_para(valeur : int) ->void:
	if valeur > life :
		valeur = life
	para += valeur
	life -= valeur
	update_lifebar()
