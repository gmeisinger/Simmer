extends Control

"""
Dialog box
George Meisinger



"""

var height
var width
var x_pos
var y_pos

#var lines = []

var color = Color(1,1,1)

onready var tie = $Panel/TextInterfaceEngine
onready var speaker_label = $speaker/Label
onready var active = false

onready var locations = {
	"center" : get_viewport_rect().size / 2.0
	}

var current_script: String = ""

signal next_step()
signal script_complete(script_name)

func _ready():
	SignalMgr.register_publisher(self, "script_complete")
	# Get screen vars
	set_screen_vars()
	hide()
	tie.set_color(color)
	#play_script("res://assets/dialog/scene3.json")

func _process(delta):
	if active and Input.is_action_just_pressed("ui_accept"):
		skip()

func quick_message(msg : String, duration = 3.0):
	tie.reset()
	buff_text(msg)
	delay(duration)
	show(rect_position)
	output()
	yield(tie, "buff_end")
	hide()

func play_script(script_name : String):
	current_script = script_name
	#load script
	var lines = read_script(script_name)
	#play each line
	for line in lines:
		play_line(line)
		yield(tie, "buff_end")
		yield(self, "next_step")
		hide()
		yield($Tween, "tween_completed")
	emit_signal("script_complete", current_script)
		
func play_line(line):
	#set speaker and location
	for step in line.steps:
		buff_text(step.text, step.speed)
	show(line.location, line.speaker)
	output()

func set_screen_vars():
	var vp_size = get_viewport_rect().size
	locations["center_bottom"] = locations["center"] + Vector2(0, vp_size.y / 4.0)
	locations["center_top"] = locations["center"] - Vector2(0, vp_size.y / 4.0)
	locations["center_left"] = locations["center"] - Vector2(vp_size.x / 4.0, 0)
	locations["center_right"] = locations["center"] + Vector2(vp_size.x / 4.0, 0)
	locations["lower_left"] = locations["center"] - Vector2(vp_size.x / 4.0, 0) + Vector2(0, vp_size.y / 4.0)
	locations["lower_right"] = locations["center"] + Vector2(vp_size.x / 4.0, 0) + Vector2(0, vp_size.y / 4.0)
	locations["upper_left"] = locations["center"] - Vector2(vp_size.x / 4.0, 0) - Vector2(0, vp_size.y / 4.0)
	locations["upper_right"] = locations["center"] + Vector2(vp_size.x / 4.0, 0) - Vector2(0, vp_size.y / 4.0)
	
func set_speaker(speaker : String):
	if speaker == "":
		speaker_label.visible = false
	else:
		speaker_label.set_text(speaker.capitalize())
		speaker_label.visible = true

func move_to(pt : Vector2):
	rect_position = pt

func hide():
	#visible = false
	$Tween.interpolate_property(self, "rect_scale", Vector2.ONE, Vector2.ZERO, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	tie.reset()
	active = false

func show(pt : Vector2 = Vector2(0,0), new_speaker = ""):
	if new_speaker:
		set_speaker(new_speaker)
	move_to(pt)
	$Tween.interpolate_property(self, "rect_scale", Vector2.ZERO, Vector2.ONE, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	active = true
	#visible = true

func buff_text(text : String, time : float = 0.05):
	tie.buff_text(text, time)

func delay(time : float):
	tie.buff_silence(time)

func skip():
	tie.set_turbomode(true)
	emit_signal("next_step")

func newline():
	buff_text("\n")

func output():
	tie.set_state(tie.STATE_OUTPUT)

func _on_TextInterfaceEngine_buff_end():
	tie.set_turbomode(false)


# Reading Script from file

func read_script(script_name : String):
	var script_path = "res://assets/dialog/" + script_name + ".json"
	var script_lines = []
	var script_file = File.new()
	# check for script, read it
	assert(script_file.file_exists(script_path))
	var read_result = script_file.open(script_path, File.READ)
	var data = parse_json(script_file.get_as_text())
	for line in data["lines"]:
		var new_line = Line.new(line["speaker"])
		new_line.location = locations[line["location"]]
		for step in line["steps"]:
			var new_step = Step.new(step["text"], step["time"])
			new_line.add_step(new_step)
		script_lines.append(new_line)
	script_file.close()
	return script_lines

class Line:
	var speaker
	var location : Vector2
	var steps = []
	
	func _init(_speaker : String):
		speaker = _speaker
	
	func add_step(step):
		steps.append(step)

class Step:
	var text
	var speed = 0.05
	
	func _init(_text : String, _speed : float = 0.05):
		text = _text
		speed = _speed
