extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.state = host.TWO
	host.position.y += 3

func update(delta):
	host.point_at(host.get_target())

func exit():
	host.position.y -= 3