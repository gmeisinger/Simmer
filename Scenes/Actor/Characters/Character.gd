extends "res://Scenes/Actor/actor.gd"

const ARRIVAL_DISTANCE = 10.0

onready var move_target = get_position()

func process_movement(delta):
	if position.distance_to(move_target) > ARRIVAL_DISTANCE:
		var delta_vel = position.direction_to(move_target) * acceleration
		velocity += delta_vel
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	elif velocity != Vector2.ZERO:
		velocity = velocity / 3.0
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
		h_face = sign(velocity.x)
	face_sprites(h_face, sign(velocity.y))

func command(action_name : String):
	pass

func interact_with(target):
	if not target.has_method("interact"):
		return
	target.interact(self)

func get_target():
	var target_vec = Vector2(h_face * 100.0, 0.0)
	return target_vec
	