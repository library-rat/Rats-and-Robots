extends CharacterBody2D

func _ready():
	set_velocity(Vector2(100, 500))

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		if collision_info.get_collider().is_in_group("Brick"):
			collision_info.get_collider().queue_free()
