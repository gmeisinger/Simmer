extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	if not host.check_focus():
		change_state("idle")
	elif not host.focus_target.get_interactable().active:
		change_state("idle")
	elif host.global_position.distance_to(host.focus_target.global_position) > host.INTERACT_RANGE:
		var approach_comm = Command.get_approach_command(host.focus_target, host.INTERACT_RANGE)
		var interact_comm = Command.get_interact_command(host.focus_target, host.interact_action)
		host.queue_command(approach_comm)
		host.queue_command(interact_comm)
	else:
		host.interact_with(host.focus_target.get_interactable(), host.interact_action)
	change_state("idle")