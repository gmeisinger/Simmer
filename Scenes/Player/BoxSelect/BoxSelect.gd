extends Node2D

const SINGLE_SELECT_TIMER = 0.2

signal detected_list_updated(detected)
signal hard_select(selected)
var active = false
var detected = []

var start_pos = Vector2()

onready var player = get_parent()
onready var shape = $Area2D/CollisionShape2D.get_shape()

var lifetime = 0.0

func _ready():
	$ColorRect.color = globals.get("color_dark_green")
	$ColorRect.color.a = 0.5
	$ColorRect.hide()
	set_process(false)
	
func _process(delta):
	lifetime += delta
	update_rect(get_global_mouse_position())
	

func start(pos : Vector2):
	lifetime = 0.0
	start_pos = pos
	active = true
	set_process(true)
	$ColorRect.rect_position = pos
	$ColorRect.show()
	$Area2D.monitoring = true

func update_rect(end_pos : Vector2):
	var center = Vector2((start_pos.x + end_pos.x)/2.0, (start_pos.y + end_pos.y)/2.0)
	$Area2D.set_position(center)
	var extent_x = (max(end_pos.x,start_pos.x) - min(end_pos.x,start_pos.x))/2.0
	var extent_y = (max(end_pos.y,start_pos.y) - min(end_pos.y,start_pos.y))/2.0
	shape.set_extents(Vector2(extent_x, extent_y))
	$ColorRect.rect_size = Vector2(extent_x * 2, extent_y * 2)
	$ColorRect.rect_scale.x = sign(end_pos.x - start_pos.x)
	$ColorRect.rect_scale.y = sign(end_pos.y - start_pos.y)
	player.set_soft_select(detected)

func end():
	if not detected.empty():
		if lifetime > SINGLE_SELECT_TIMER:
			emit_signal("hard_select", detected)
		else:
			emit_signal("hard_select", [detected[0]])
	active = false
	$Area2D.monitoring = false
	detected.clear()
	$Area2D.set_position(Vector2.ZERO)
	set_process(false)
	$ColorRect.rect_size = Vector2.ZERO
	$ColorRect.hide()

func _on_Area2D_area_entered(area):
	# the interactable node is the area's parent
	detected.append(area.get_parent())
	emit_signal("detected_list_updated", detected)


func _on_Area2D_area_exited(area):
	if active:
		if detected.has(area.get_parent()):
			print("interactable found, removing...")
			area.get_parent().deselect()
			detected.erase(area.get_parent())
		else:
			print("list did not contain area's parent")
		emit_signal("detected_list_updated", detected)