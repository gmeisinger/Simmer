extends Node2D

"""
The player class

keeps track of interactables detected by mouse or box select

issues commands to hard selected units

"""

export var debug_on : bool

signal set_tooltip(tt_target)

var soft_selected = []
var hard_selected = []
var mouse_hovers = []

var action_menu_source = []
var action_menu_target = null

var tooltip_target = null

export var player_color : Color

onready var zone = get_parent()

func _ready():
	globals.set("player", self)
	SignalMgr.register_subscriber(self, "mouse_over", "_on_mouse_over")

func _input(event):
	if event.is_action_released("pause"):
		#if get_tree().is_paused():
		#	get_tree().set_pause(false)
		#else:
		#	get_tree().set_pause(true)
		#	Physics2DServer.set_active(true)
		if Engine.time_scale == 1.0:
			Engine.time_scale = 0.1
		else:
			Engine.time_scale = 1.0
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
			choices = get_additional_commands(action_menu_source, action_menu_target, choices)
			$ActionMenu.display(get_viewport().get_mouse_position(), choices)

# Command Methods

func issue_command(comm, immediate = true):
	if hard_selected.empty(): return
	# DEBUG
	if debug_on:
		var debug = "ISSUING COMMAND : " + comm.action_name
		print_to_debug(debug)
	#
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
		var randomness = hard_selected.size() * 0.75
		unit.clear_commands()
		unit.execute_command(Command.get_move_command(pos, randomness))

func get_additional_commands(source : Array, target, command_list):
	var ret = []
	
	# compare source units and target
	# can player units attack? steal? chat?
	# some actions may be available to ONE selected unit, but not as a "multi-command"
	
	# I have a property in most objects called object_type
	var obj_type = target.get_parent().object_type
	if not obj_type:
		print_to_debug("no obj type")
		print("no obj type")
		return command_list
	match(obj_type):
		"character":
			# if the target is a player, we don't want the interact options
			if target.is_player():
				#stubs:
				# if source.size() == 1:
				# 	ret.append("trade")
				return ret
			
			# if the target is not a player,
			# we will have to judge them somehow
			# for now i'm gonna allow attacking
			
			ret.append("Attack")
			
		"item":
			return command_list
	
	# Default
	return ret + command_list

func print_to_debug(text : String):
	var old_text = $player_camera/hud/output.get_text()
	var new_text = old_text + "\n" + text
	$player_camera/hud/output.set_text(new_text)

func _on_mouse_over(set, interactable_node):
	if set:
		mouse_hovers.append(interactable_node)
	else:
		interactable_node.deselect()
		mouse_hovers.erase(interactable_node)
	update_tooltip()
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
	#emit_signal("update_tooltip", mouse_hovers[0].get_host())

func hard_select(units : Array):
	#deselect old units
	if not hard_selected.empty():
		for interactable in hard_selected:
			interactable.hard_deselect()
	hard_selected.clear()
	for unit in units:
		hard_selected.append(unit)
		unit.hard_select(player_color)
	if debug_on:
		var string = "SELECTED : " + String(units)
		print_to_debug(string)

func update_tooltip():
	if not mouse_hovers.empty():
		tooltip_target = mouse_hovers[0].get_host()
		emit_signal("set_tooltip", tooltip_target)

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
	match(action_text):
		"Attack":
			var attack_command = Command.get_attack_command(action_menu_target.get_parent())
			issue_command(attack_command)
		_:
			# interact commands are the default case
			var interact_command = Command.get_interact_command(action_menu_target.get_parent(), action_text)
			issue_command(interact_command)
			action_menu_target.emit_signal("mouse_over", false, action_menu_target)
			action_menu_target = null
