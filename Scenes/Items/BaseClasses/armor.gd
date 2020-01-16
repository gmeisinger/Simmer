extends "res://Scenes/Items/BaseClasses/equippable.gd"

export var hide_host = false

func _ready():
	pass

func attach_to_host(_host):
	host = _host
	host.connect("frame_changed", self, "update_frame")
	if hide_host:
		host.self_modulate.a = 0.0

func remove_from_host():
	host.disconnect("frame_changed", self, "update_frame")

func update_frame():
	$Sprite.frame = host.frame
	$Sprite.flip_h = host.flip_h
	if hide_host:
		host.self_modulate.a = 0.0

func flip(f):
	$Sprite.flip_h = f