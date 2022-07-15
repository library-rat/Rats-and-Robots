tool
class_name Player
extends "res://Scène principale/Gameboard/Unit/Unit.gd"




func _on_AfficheactionActive_move_player(valeur):
	move_range = valeur
	print(move_range)
