extends "res://Scenes/Items/BaseClasses/item.gd"

export var slot : String
var host

func attach_to_host(_host):
	#this is where the item "locks" to the host visually
	pass

func remove_from_host():
	pass

func interact(source : Node, command : String):
	match(command):
		"Equip":
			cur_owner.remove_child(self)
			source.equip(self)
			$item_state.change_state("equipped")
			cur_owner = source
		"Pickup":
			$item_state.change_state("stored")
			cur_owner.remove_child(self)
			source.get_node("inventoryMgr").add_item(self)
			cur_owner = source