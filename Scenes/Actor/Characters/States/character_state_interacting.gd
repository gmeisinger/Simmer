extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.interact_with(host.interact_target)
	change_state("idle")