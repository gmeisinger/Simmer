extends "res://Scenes/Items/BaseClasses/active_item.gd"

export var throw_speed = 7.0
export var fetchable = false

var global_target : Vector2
var throw_dist : float
var velocity : Vector2

func primary(target : Vector2):
	global_target = global_position + target
	throw_dist = target.length()
	velocity = target.normalized() * throw_speed
	cur_owner.get_inventory().throw_item(self)