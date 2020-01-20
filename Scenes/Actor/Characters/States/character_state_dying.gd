extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.play_anim("die")

func update(delta):
	if not host.anim_playing():
		host.die()