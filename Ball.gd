extends KinematicBody2D

var velocity = Vector2(0, 500)

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		if collision_info.collider.is_in_group("Brick"):
			collision_info.collider.queue_free()
