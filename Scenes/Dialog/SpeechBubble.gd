extends "res://Scenes/Dialog/DialogBox.gd"

func _ready():
	set_process(false)

func say(msg):
	quick_message(msg)