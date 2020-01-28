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

func get_pathfind_command(target : Vector2):
	var comm = get_script().new()
	comm.action_name = "pathfind"
	comm.next_state = "pathfinding"
	comm.set_parameter("move_target", target)
	return comm

func get_interact_command(target_unit, action_name : String):
	var comm = get_script().new()
	comm.action_name = "interact"
	comm.next_state = "interacting"
	comm.set_parameter("focus_target", target_unit)
	comm.set_parameter("focus_target_valid", true)
	comm.set_parameter("focus_target_wr", weakref(target_unit))
	return comm

func get_approach_command(target_unit, target_distance):
	var comm = get_script().new()
	comm.action_name = "approach"
	comm.next_state = "approaching"
	comm.set_parameter("focus_target", target_unit)
	comm.set_parameter("focus_target_valid", true)
	comm.set_parameter("focus_target_wr", weakref(target_unit))
	comm.set_parameter("move_threshold", target_distance)
	return comm

func get_attack_command(target_unit):
	var comm = get_script().new()
	comm.action_name = "attack"
	comm.next_state = "attacking"
	comm.set_parameter("focus_target", target_unit)
	comm.set_parameter("focus_target_valid", true)
	comm.set_parameter("focus_target_wr", weakref(target_unit))
	return comm