extends Node2D

signal mouse_over()

var selected = false
var select_locked = false
var active = true
onready var outline_material = load("res://Assets/Shaders/Outline/outline.tres")

export(String, MULTILINE) var option_lines
var options = []
var choice

onready var host = get_parent()
onready var area = $area

func _ready():
	SignalMgr.register_publisher(self, "mouse_over")
	read_options()

func read_options():
	options.clear()
	for op in option_lines.split("\n"):
		options.append(op.capitalize())

func get_options():
	return options

func set_player(set : bool):
	$area.set_collision_layer_bit(1, set)

func set_select(_selected : bool = true):
	selected = _selected
	if selected:
		host.set_material(outline_material.duplicate())
	else:
		host.set_material(null)

func set_outline_color(color : Color):
	var mat = host.get_material()
	if not mat: return
	else:
		mat.set("shader_param/outline_color", color)

func select_lock(set : bool):
	select_locked = set

func select():
	if active and not select_locked:
		set_select(true)

func deselect():
	if active and not select_locked:
		set_select(false)	

func hard_select(color : Color):
	# if active?
	select()
	set_outline_color(color)
	select_lock(true)

func hard_deselect():
	set_outline_color(Color.white)
	select_lock(false)
	deselect()

func set_active(act = true):
	area.monitorable = act
	active = act
	if !act:
		set_select(false)

func interact(source : Node, selected : String = ""):
	if active:
		#read_options()
		if selected == "" or !options.has(selected):
			selected = options[0]
		host.interact(source, selected)

func _on_area_mouse_entered():
	if active:
		emit_signal("mouse_over", true, self)


func _on_area_mouse_exited():
	if active:
		emit_signal("mouse_over", false, self)
