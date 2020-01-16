extends Node

var props = {}
var mask_name_to_bit = {}

func set(name, value):
	props[name] = value
	
func get(name):
	if !props.has(name):
		return null
	return props[name]
	
func erase(name):
	props.erase(name)




func set_layer_map():
	for i in range(1, 21):
		var layer_name = ProjectSettings.get_setting(str("layer_names/2d_physics/layer_", i))
		if not layer_name:
			layer_name = str("Layer ", i)
		mask_name_to_bit[layer_name] = i - 1

func get_layer(lname : String):
	if lname in mask_name_to_bit.keys():
		return mask_name_to_bit[lname]
	else:
		return null

func _ready():
	set_layer_map()
	var colors = []
	set("color_black", Color("000000"))
	set("color_white", Color("FFFFFF"))
	set("color_green", Color("5ac54f"))
	set("color_dark_green", Color("1e6f50"))
	set("color_red", Color("8e251d"))
	set("color_dark_red", Color("891e2b"))
	set("color_blue", Color("3003d9"))
	set("color_dark_blue", Color("0c0293"))
	set("color_brown", Color("8a4836"))
	set("color_dark_brown", Color("5d2c28"))
	set("color_midnight_blue", Color("03193f"))
	set("color_dark_purple", Color("3b1443"))
	set("color_dark_gray", Color("1b1b1b"))