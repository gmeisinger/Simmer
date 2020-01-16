extends Control

var colors = []

var hair = []
var shirt = []
var pants = []

var hair_index = 0
var hair_color_index = 0
var shirt_index = 0
var shirt_color_index = 0
var pants_index = 0
var pants_color_index = 0

onready var model = $panel/actor

func _ready():
	get_colors()
	randomize_colors()
	get_paths()
	hair_index = randi() % hair.size()
	update_hair()
	update_pants()
	update_shirt()
	$back_button.grab_focus()
	#$panel/vert_box/hair_section/hair_left_button.grab_focus()

func get_colors():
	for key in globals.props.keys():
		if key.begins_with("color"):
			colors.append(globals.get(key))

func randomize_colors():
	hair_color_index = randi() % colors.size()
	shirt_color_index = randi() % colors.size()
	pants_color_index = randi() % colors.size()

func update_hair():
	var tex = hair[hair_index]
	var col = colors[hair_color_index]
	model.set_hair(tex)
	model.set_hair_color(col)
	$panel/vert_box/hair_section/Label.set_text(String(hair_index + 1))
	$panel/vert_box/hair_color_section/hair_color.color = col

func update_shirt():
	var tex = shirt[shirt_index]
	var col = colors[shirt_color_index]
	model.set_shirt(tex)
	model.set_shirt_color(col)
	$panel/vert_box/shirt_section/Label.set_text(String(shirt_index + 1))
	$panel/vert_box/shirt_color_section/shirt_color.color = col
	
func update_pants():
	var tex = pants[pants_index]
	var col = colors[pants_color_index]
	model.set_pants(tex)
	model.set_pants_color(col)
	$panel/vert_box/pants_section/Label.set_text(String(pants_index + 1))
	$panel/vert_box/pants_color_section/pants_color.color = col

func get_paths():
	var dir = Directory.new()
	#HAIR
	var path = "res://Assets/Sprites/Actor/hair"
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".png"):
			var full_path = path + "/" + file
			var tex = load(full_path)
			hair.append(tex)
	dir.list_dir_end()
	#SHIRT
	path = "res://Assets/Sprites/Actor/shirts"
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".png"):
			var full_path = path + "/" + file
			var tex = load(full_path)
			shirt.append(tex)
	dir.list_dir_end()
	#PANTS
	path = "res://Assets/Sprites/Actor/pants"
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".png"):
			var full_path = path + "/" + file
			var tex = load(full_path)
			pants.append(tex)
	dir.list_dir_end()

func _on_hair_left_button_button_up():
	if hair_index == 0:
		hair_index = hair.size() - 1
	else:
		hair_index -= 1
	update_hair()


func _on_hair_right_button_button_up():
	if hair_index == hair.size() - 1:
		hair_index = 0
	else:
		hair_index += 1
	update_hair()


func _on_shirt_left_button_button_up():
	if shirt_index == 0:
		shirt_index = shirt.size() - 1
	else:
		shirt_index -= 1
	update_shirt()


func _on_shirt_right_button_button_up():
	if shirt_index == shirt.size() - 1:
		shirt_index = 0
	else:
		shirt_index += 1
	update_shirt()


func _on_pants_left_button_button_up():
	if pants_index == 0:
		pants_index = pants.size() - 1
	else:
		pants_index -= 1
	update_pants()


func _on_pants_right_button_button_up():
	if pants_index == pants.size() - 1:
		pants_index = 0
	else:
		pants_index += 1
	update_pants()


func hair_color_left():
	if hair_color_index == 0:
		hair_color_index = colors.size() - 1
	else:
		hair_color_index -= 1
	update_hair()


func hair_color_right():
	if hair_color_index == colors.size() - 1:
		hair_color_index = 0
	else:
		hair_color_index += 1
	update_hair()


func shirt_color_left():
	if shirt_color_index == 0:
		shirt_color_index = colors.size() - 1
	else:
		shirt_color_index -= 1
	update_shirt()


func shirt_color_right():
	if shirt_color_index == colors.size() - 1:
		shirt_color_index = 0
	else:
		shirt_color_index += 1
	update_shirt()


func pants_color_left():
	if pants_color_index == 0:
		pants_color_index = colors.size() - 1
	else:
		pants_color_index -= 1
	update_pants()


func pants_color_right():
	if pants_color_index == colors.size() - 1:
		pants_color_index = 0
	else:
		pants_color_index += 1
	update_pants()


func check_name(new_text):
	if new_text.length() > 0:
		$start_button.disabled = false
	else:
		$start_button.disabled = true


func _on_start_button_button_up():

	var fashion_dict = {
		hair = hair[hair_index -1],
		hair_color = colors[hair_color_index],
		shirt = shirt[shirt_index -1],
		shirt_color = colors[shirt_color_index],
		pants = pants[pants_index -1],
		pants_color = colors[pants_color_index],
		player_name = $panel/name.get_text()
	}
		
	globals.set("player_fashion", fashion_dict)
	#transitionMgr.transitionTo("res://scenes/zones/complex1.tscn")
	$panel/actor.play_anim("dodge")
	yield($panel/actor/AnimationPlayer, "animation_finished")
	$panel/actor.play_anim("idle")
	pass # Replace with function body.


func _on_back_button_button_up():
	#transitionMgr.transitionTo("res://scenes/menu/title/titlescreen.tscn")
	pass
