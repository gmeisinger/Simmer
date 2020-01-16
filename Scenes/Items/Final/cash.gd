extends "res://Scenes/Items/BaseClasses/item.gd"

func interact(source : Node, command : String):
	match(command):
		"Pickup":
			print("cash picked up")
			queue_free()