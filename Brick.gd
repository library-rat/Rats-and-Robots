extends StaticBody2D

@export var color : String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if color == "Blue" :
		$AnimatedSprite2D.frame = 0
	if color == "Green" :
		$AnimatedSprite2D.frame = 2
	if color == "Red" :
		$AnimatedSprite2D.frame = 6
	if color == "Yellow" :
		$AnimatedSprite2D.frame = 12
