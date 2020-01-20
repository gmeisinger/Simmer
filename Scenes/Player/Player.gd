extends Node2D

"""
The player class
	handles input
	issues commands to units
	keeps track of selected units
	
Unit selection
	possibilities:
		player selects ONE unit
		player selects multiple units with BoxSelect
			this will soft-select all units in the box, then
			hard select all soft-selected on release
			
Unit Command
	will issue the command to ALL hard-selected units
	
TODO:
	completely overhaul _input()
		need more elegant, streamlined code for selecting and commanding
	
"""


var soft_selected = []
var hard_selected = []
var mouse_hovers = []

var action_menu_source = []
var action_menu_target = null

export var player_color : Color

func _ready():
	globals.set("player", self)
	SignalMgr.register_subscriber(self, "mouse_over", "_on_mouse_over")

func _input(event):
	if event.is_action_pressed("select"):
		$BoxSelect.start(get_global_mouse_position())
	elif event.is_action_released("select"):
		$BoxSelect.end()
	elif event.is_action_pressed("command"):
		pass
	elif event.is_action_released("command"):
		if mouse_hovers.empty():
			# use this special method to randomize the destinations
			# this prevents stacking
			move_units(get_global_mouse_position())
		else:
			action_menu_source = hard_selected.duplicate()
			action_menu_target = mouse_hovers[0]
			var choices = action_menu_target.get_options()
			choices += get_additional_commands(action_menu_source, action_menu_target)
			$ActionMenu.display(get_viewport().get_mouse_position(), choices)

# Command Methods

func issue_command(comm, immediate = true):
	if hard_selected.empty(): return
	for interactable in hard_selected:
		var unit = interactable.get_parent()
		if immediate:
			unit.execute_command(comm)
		else:
			unit.queue_command(comm)

func move_units(pos : Vector2):
	if hard_selected.empty(): return
	for interactable in hard_selected:
		var unit = interactable.get_parent()
		unit.execute_command(Command.get_move_command(pos, hard_selected.size()))

func get_additional_commands(source : Array, target):
	var ret = []
	# compare source units and target
	# can player units attack? steal? chat?
	# some actions may be available to ONE selected unit, but not as a "multi-command"
	return ret

func _on_mouse_over(set, interactable_node):
	if set:
		mouse_hovers.append(interactable_node)
	else:
		interactable_node.deselect()
		mouse_hovers.erase(interactable_node)
	update_mouse_hover()

func set_soft_select(detected):
	pass

func update_mouse_hover():
	if mouse_hovers.empty(): return
	if mouse_hovers.size() == 1:
		mouse_hovers[0].select()
		return
	mouse_hovers[0].deselect()
	mouse_hovers.sort_custom(self, "sort_by_position")
	mouse_hovers[0].select()

func hard_select(units : Array):
	#deselect old units
	if not hard_selected.empty():
		for interactable in hard_selected:
			interactable.hard_deselect()
	hard_selected.clear()
	for unit in units:
		hard_selected.append(unit)
		unit.hard_select(player_color)


static func sort_by_position(a, b):
	if a.global_position.y > b.global_position.y:
		return true
	return false

func _on_BoxSelect_detected_list_updated(detected):
	if not detected: return
	soft_selected.clear()
	for interactable in detected:
		interactable.select()
		soft_selected.append(interactable)


func _on_BoxSelect_hard_select(selected):
	hard_select(selected)


func _on_ActionMenu_item_selected(action_text):
	if hard_selected.empty(): return
	var interact_command = Command.get_interact_command(action_menu_target, action_text)
	issue_command(interact_command)
	action_menu_target = null
