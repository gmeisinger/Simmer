extends Node

const RANDOM_POSITION_VARIANCE = 16.0

var action_name : String
var next_state : String
var parameters  = {}

func set_parameter(_name : String, _val):
	parameters[_name] = _val

func apply_random_offset(pos : Vector2, randomness : float):
	var r_range = RANDOM_POSITION_VARIANCE * randomness
	pos.x = rand_range(pos.x - r_range, pos.x + r_range)
	pos.y = rand_range(pos.y - r_range, pos.y + r_range)
	return pos

# Standard Commands

func get_move_command(target : Vector2, randomness = 0.0):
	var comm = get_script().new()
	comm.action_name = "move"
	comm.next_state = "moving"
	if randomness > 0.0:
		target = apply_random_offset(target, randomness)
	comm.set_parameter("move_target", target)
	return comm

func get_interact_command(target_interactable, action_name : String):
	var comm = get_script().new()
	comm.action_name = "interact"
	comm.next_state = "interacting"
	comm.set_parameter("interact_target", target_interactable)
	return comm