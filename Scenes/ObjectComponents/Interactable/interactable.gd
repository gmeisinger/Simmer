extends Node2D

signal mouse_over()

var selected = false
var select_locked = false
onready var outline_material = load("res://Assets/Shaders/Outline/outline.tres")

export(String, MULTILINE) var option_lines = "Inspect"
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
	if not select_locked:
		set_select(true)

func deselect():
	if not select_locked:
		set_select(false)

func set_active(act = true):
	area.monitorable = act
	if !act:
		set_select(false)

func interact(source : Node):
	read_options()
	var selected = options[0]
	if options.size() > 1:
		options.append("Cancel")
		#emit_signal("show_action_menu", options)
		#waiting_for_choice = true
		#yield(globals.get("action_menu"), "action_menu_choice")
		#selected = choice
	host.interact(source, selected)

func _on_area_mouse_entered():
	emit_signal("mouse_over", true, self)


func _on_area_mouse_exited():
	emit_signal("mouse_over", false, self)
