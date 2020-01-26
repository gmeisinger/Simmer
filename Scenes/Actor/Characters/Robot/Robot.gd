extends "res://Scenes/Actor/Characters/Character.gd"



onready var faces = {
	"default" : Face.new("0.0", Color.white),
	"trade" : Face.new("$_$", Color.green),
	"sad" : Face.new("p.p", Color.blue),
	"dead" : Face.new("x-x", Color.white),
	"angry" : Face.new(">.<", Color.red),
	"blink" : Face.new("-.-", Color.white)
	}

func make_face(f_name : String):
	var face = faces.get(f_name)
	if not face:
		return
	$facial_expression.set_text(face.text)
	$facial_expression.set("custom_colors/font_color", face.color)

class Face:
	
	var text : String
	var color : Color
	
	func _init(_text : String, _color : Color):
		text = _text
		color = _color