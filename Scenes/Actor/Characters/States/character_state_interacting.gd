extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	if not host.interact_target:
		change_state("idle")
	elif host.global_position.distance_to(host.interact_target.global_position) > host.INTERACT_RANGE:
		var move_comm = Command.get_move_command(host.interact_target.global_position, 1.0)
		var interact_comm = Command.get_interact_command(host.interact_target, host.interact_action)
		host.queue_command(move_comm)
		host.queue_command(interact_comm)
	else:
		host.interact_with(host.interact_target, host.interact_action)
	change_state("idle")