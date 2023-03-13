extends StaticBody2D

export var color : String
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if color == "Blue" :
		$AnimatedSprite.frame = 0
	if color == "Green" :
		$AnimatedSprite.frame = 2
	if color == "Red" :
		$AnimatedSprite.frame = 6
	if color == "Yellow" :
		$AnimatedSprite.frame = 12
