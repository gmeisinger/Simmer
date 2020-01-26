extends "res://Scenes/Items/BaseClasses/item.gd"

export var amount : int

func _ready():
	if not amount:
		amount = 1

func get_object_name():
	var string = "$" + String(amount)
	return String(string)

func interact(source : Node, command : String):
	match(command):
		"Pickup":
			print("cash picked up")
			# check interactable
			if $interactable.active:
				$interactable.emit_signal("mouse_over", false, $interactable)
				$interactable.set_active(false)
				globals.get("player").update_mouse_hover()
				#yield(get_tree().create_timer(0.1), "timeout")
			queue_free()