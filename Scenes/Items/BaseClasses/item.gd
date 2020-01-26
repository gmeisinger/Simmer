extends Node2D

var object_type = "item"

export var icon_rect : Rect2
export var item_name : String
export var description : String

var team_name : String
var cur_owner

func get_object_name():
	return self.item_name

func change_state(state : String):
	$item_state.change_state(state)
	
func set_ownership(character):
	cur_owner = weakref(character)

func get_cur_owner():
	return cur_owner.get_ref()

func get_sprite():
	return $Sprite.texture.duplicate()

func get_icon_rect():
	return icon_rect

func get_interactable():
	return get_node("interactable")

func get_team():
	return team_name

func set_team(t_name : String):
	team_name = t_name

func interact(source : Node, command : String):
	pass

func get_state():
	return $item_state.current_state.name