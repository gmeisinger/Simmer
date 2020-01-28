extends Camera2D

const DAMP_TIME = 0.5
const PAN_TIME = 0.01
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

func zoom_at_point(new_zoom, point):
	var c0 = global_position # camera position
	var v0 = get_viewport().size # vieport size
	var c1 # next camera position
	var z0 = zoom # current zoom value
	var z1 = new_zoom # next zoom value
	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
	var new_global_position = c1
	tween.interpolate_property(self, "zoom", zoom, new_zoom, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(self, "global_position", global_position, new_global_position, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _input(event):
	if event.is_action_pressed("mouse_pan"):
		mouse_panning = true
		last_mouse_pos = get_global_mouse_position()
	elif event.is_action_released("mouse_pan"):
		mouse_panning = false
	elif event.is_action("zoom_in"):
		var new_zoom = max(MIN_ZOOM, zoom.x - 0.1)
		var vec = Vector2(new_zoom, new_zoom)
		zoom_at_point(vec, get_viewport().get_mouse_position())
		#tween.interpolate_property(self, "zoom", zoom, vec, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		#tween.start()
	elif event.is_action("zoom_out"):
		var new_zoom = min(MAX_ZOOM, zoom.x + 0.1)
		var vec = Vector2(new_zoom, new_zoom)
		zoom_at_point(vec, get_viewport().get_mouse_position())
		#tween.interpolate_property(self, "zoom", zoom, vec, DAMP_TIME/2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		#tween.start()

func _physics_process(delta):
	if mouse_panning:
		var mouse_change = get_global_mouse_position() - last_mouse_pos
		position -= mouse_change
		#$Tween.interpolate_property(self, "position", position, new_pos, PAN_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN)
		#$Tween.start()
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