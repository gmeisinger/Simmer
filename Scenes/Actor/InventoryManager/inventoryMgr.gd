extends Node

export var slots : int = 10
export var auto_equip = false

onready var host = get_parent()

#equipment slots
var equips = {
	"armor" : null,
	"helmet" : null,
	"weapon" : null
	}

var items = []

func get_item_count():
	return items.size()

func is_full():
	if items.size() >= slots:
		return true
	else:
		return false

func drop_all_items():
	for item in items:
		drop_item(item)

func add_item(item_ref):
	if not item_ref: return
	if is_full():
		#notify inv full
		return
	items.append(item_ref)
	if auto_equip and item_ref.slot and equips[item_ref.slot] == null:
		equip(item_ref)

func drop_item(item_ref):
	if not item_ref: return
	var last_pos = item_ref.global_position
	if item_ref.get_state() == "stored":
		last_pos = host.global_position
	if is_equipped(item_ref):
		unequip(item_ref)
	#make it a pickup
	#add it to zone obj list
	globals.get("cur_scene").add_object(item_ref)
	item_ref.change_state("pickup")
	item_ref.position = last_pos
	items.erase(item_ref)

func throw_item(item_ref):
	if not item_ref: return
	var last_pos = item_ref.global_position
	if is_equipped(item_ref):
		unequip(item_ref)
	#make it a pickup
	#add it to zone obj list
	globals.get("cur_scene").add_object(item_ref)
	item_ref.change_state("thrown")
	item_ref.position = last_pos
	items.erase(item_ref)

func unequip(item_ref):
	if not item_ref: return
	equips[item_ref.slot] = null
	host.unequip(item_ref.slot)
	item_ref.change_state("stored")

func equip(item_ref):
	if not item_ref: return
	equips[item_ref.slot] = item_ref
	host.equip(item_ref)
	item_ref.change_state("equipped")

func equip_next_weapon(direction = 1):
	direction = sign(direction)
	var weapons = []
	for item in items:
		if item.slot == "weapon":
			weapons.append(item)
	if weapons.size() < 1: return
	var cur_weapon = weapons.find(equips["weapon"])
	var next = cur_weapon + direction
	if next == -1:
		next = weapons.size() - 1
	elif next == 0:
		pass
	else:
		next = next % weapons.size()
	equip(weapons[next])
	

func is_equipped(item_ref):
	if not item_ref: return false
	var state = item_ref.get_node("item_state").current_state.name
	if state == "equipped":
		return true
	else: 
		return false

func can_equip(item_ref):
	var can = true

func print_items():
	for item in items:
		print(item.name)