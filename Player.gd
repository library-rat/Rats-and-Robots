extends StaticBody2D

export var speed = 550.0
var left_limit = 0
var right_limit = 0

func _ready():
	# Enable the processing function for this node
	set_process(true)

	# Set the limits to the paddle based on the screen size
	left_limit = get_viewport_rect().position.x 
	right_limit = get_viewport_rect().position.x + get_viewport_rect().size.x 

	$"AnimatedSprite".play("default")

func _process(delta):
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		# If the player is pressing the left arrow, move to the left
		# which means going in the negative direction of the X axis
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		# Same as above, but this time we go in the positive direction
		direction = 1

	# Create a movement vector
	var movement = Vector2(direction * speed * delta, 0)

	# Move the paddle using vector arithmetic
	set_position(get_position() + movement)

	# Here we clamp the paddle position to not go off the screen
	if get_position().x < left_limit:
		set_position(Vector2(left_limit, get_position().y))
	elif get_position().x > right_limit:
		set_position(Vector2(right_limit, get_position().y))
