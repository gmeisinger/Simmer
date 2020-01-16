extends Node2D

export var icon_rect : Rect2
export var item_name : String = "Basic Item"
export var description : String = "An item."

var cur_owner

func change_state(state : String):
	$item_state.change_state(state)

func get_sprite():
	return $Sprite.texture.duplicate()

func get_icon_rect():
	return icon_rect

func interact(source : Node, command : String):
	pass

func get_state():
	return $item_state.current_state.name