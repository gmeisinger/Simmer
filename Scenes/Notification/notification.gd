extends Control

var DURATION = 1.0
var lifetime = 0.0

func notify(_position : Vector2, _text :String):
	rect_position = _position
	$Label.text = _text

func _process(delta):
	rect_position.y -= 1.0
	lifetime += delta
	if lifetime > DURATION:
		queue_free()