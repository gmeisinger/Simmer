extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	if not host.check_interact():
		change_state("idle")
	elif not host.interact_target.get_interactable().active:
		change_state("idle")
	elif host.global_position.distance_to(host.interact_target.global_position) > host.INTERACT_RANGE:
		var approach_comm = Command.get_approach_command(host.interact_target, host.INTERACT_RANGE)
		var interact_comm = Command.get_interact_command(host.interact_target, host.interact_action)
		host.queue_command(approach_comm)
		host.queue_command(interact_comm)
	else:
		host.interact_with(host.interact_target.get_interactable(), host.interact_action)
	change_state("idle")