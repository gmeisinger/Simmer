extends "res://Scenes/StateMachine/baseState.gd"

var interactable

func enter():
	if host.has_node("hands"):
		host.get_node("hands").visible = false
	#cur_owner is the object list in zone
	host.cur_owner = host.get_parent()
	host.get_node("Sprite").frame = 0
	interactable = host.get_node("interactable")
	if interactable:
		interactable.set_active(true)

func exit():
	if interactable:
		interactable.set_active(false)