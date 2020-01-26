extends "res://Scenes/Items/BaseClasses/item.gd"

export var slot : String
var host

func attach_to_host(_host):
	#this is where the item "locks" to the host visually
	pass

func remove_from_host():
	pass

func interact(source : Node, command : String):
	#if not get_state() == "pickup": return
	if not get_parent(): return
	match(command):
		"Equip":
			get_parent().remove_child(self)
			source.get_node("inventoryMgr").equip(self)
			$item_state.change_state("equipped")
			cur_owner = source
		"Pickup":
			get_parent().remove_child(self)
			source.get_node("inventoryMgr").add_item(self)
			cur_owner = source