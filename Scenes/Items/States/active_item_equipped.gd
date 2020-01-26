extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.position = Vector2.ZERO
	host.get_node("Sprite").position = host.handle_offset
	host.get_node("Sprite").frame = 0
	host.get_node("hands").visible = true
	
func exit():
	#host.get_node("Sprite").position = Vector2.ZERO
	host.get_node("Sprite").frame = 0
	host.get_node("hands").visible = false