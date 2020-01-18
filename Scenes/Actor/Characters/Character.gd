extends "res://Scenes/Actor/actor.gd"

const ARRIVAL_DISTANCE = 10.0
const INTERACT_RANGE = 30.0

signal arrived_at_move_target()

var command_queue = []

onready var move_threshold = ARRIVAL_DISTANCE
onready var move_target = get_position()
var interact_target

func process_movement(delta):
	if position.distance_to(move_target) > move_threshold:
		var delta_vel = position.direction_to(move_target) * acceleration
		velocity += delta_vel
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	elif velocity != Vector2.ZERO:
		velocity = velocity / 3.0
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
			emit_signal("arrived_at_move_target")
	h_face = sign(velocity.x)
	face_sprites(h_face, sign(velocity.y))

func add_command(new_command):
	command_queue.append(new_command)

func execute_command(new_command):
	print(new_command.action_name)
	for key in new_command.parameters.keys():
		set(key, new_command.parameters[key])
	$stateMachine.change_state(new_command.next_state)

func clear_commands():
	command_queue.clear()
	$stateMachine.change_state("idle")

# THIS MEANS TO INTERACT WITH THE TARGET
func interact_with(target):
	if not target.has_method("interact"):
		return
	target.interact(self)

# THIS MEANS TO BE INTERACTED WITH BY THE TARGET
func interact(source, selected_action : String):
	print("I JUST GOT INTERACTED WITH! HIS NAME WAS...")
	print(source.name)
	print("HE WANTED TO...")
	print(selected_action)

func get_target():
	var target_vec = Vector2(h_face * 100.0, 0.0)
	return target_vec

