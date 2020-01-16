extends Camera2D

const DAMP_TIME = 0.5
const MIN_ZOOM = 0.3
const MAX_ZOOM = 1.0
const PAN_SPEED = 500.0
var mouse_panning = false
var last_mouse_pos : Vector2

onready var vp_size = get_viewport_rect().size
onready var tween = $Tween

func _ready():
	#globals.set("vp_size", vp_size)
	globals.set("player_camera", self)

func _input(event):
	if event.is_action_pressed("mouse_pan"):
		mouse_panning = true
		last_mouse_pos = get_global_mouse_position()
	elif event.is_action_released("mouse_pan"):
		mouse_panning = false
	elif event.is_action("zoom_in"):
		var new_zoom = max(MIN_ZOOM, zoom.x - 0.1)
		var vec = Vector2(new_zoom, new_zoom)
		tween.interpolate_property(self, "zoom", zoom, vec, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()
	elif event.is_action("zoom_out"):
		var new_zoom = min(MAX_ZOOM, zoom.x + 0.1)
		var vec = Vector2(new_zoom, new_zoom)
		tween.interpolate_property(self, "zoom", zoom, vec, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		tween.start()

func _physics_process(delta):
	if mouse_panning:
		var mouse_change = get_global_mouse_position() - last_mouse_pos
		position -= mouse_change
	else:
		var delta_pan = Vector2.ZERO
		if Input.is_action_pressed("pan_left"):
			delta_pan.x -= PAN_SPEED * delta
		if Input.is_action_pressed("pan_right"):
			delta_pan.x += PAN_SPEED * delta
		if Input.is_action_pressed("pan_up"):
			delta_pan.y -= PAN_SPEED * delta
		if Input.is_action_pressed("pan_down"):
			delta_pan.y += PAN_SPEED * delta
		position += delta_pan