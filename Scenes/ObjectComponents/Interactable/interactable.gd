extends Node2D

signal mouse_over()
signal update_select(_selected)

var selected = false
var select_locked = false
var active = true
export(String, FILE, "*.tres") var outline_shader
onready var outline_material = load(outline_shader)

export(String, MULTILINE) var option_lines
var options = []
var choice

onready var host = get_parent()
onready var area = $area

func _ready():
	SignalMgr.register_publisher(self, "mouse_over")
	read_options()
	var new_name = host.name
	if host.has_method("get_object_name"):
		new_name = host.get_object_name()
	set_host_name(new_name)

func get_host():
	return host

func read_options():
	options.clear()
	for op in option_lines.split("\n"):
		options.append(op.capitalize())

func get_options():
	if options.empty():
		read_options()
	return options

func set_host_name(new_name : String):
	$host_name.set_text(new_name)

func set_player(set : bool):
	$area.set_collision_layer_bit(1, set)

func is_player():
	return $area.get_collision_layer_bit(1)

func set_select(_selected : bool = true):
	emit_signal("update_select", _selected)
	selected = _selected
	$host_name.visible = selected
	if selected and outline_material:
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
		read_options()
		if selected == "" or !options.has(selected):
			selected = options[0]
		host.interact(source, selected)

func _on_area_mouse_entered():
	#print("mouse detected")
	if active:
		emit_signal("mouse_over", true, self)


func _on_area_mouse_exited():
	#print("mouse exit")
	if active:
		emit_signal("mouse_over", false, self)
