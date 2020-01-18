extends Node2D

var soft_selected = []
var selected

func _ready():
	globals.set("player", self)
	SignalMgr.register_subscriber(self, "mouse_over", "_on_mouse_over")

func _input(event):
	if event.is_action_released("select") and not soft_selected.empty():
		if selected:
			selected.select_lock(false)
			selected.deselect()
			selected.set_outline_color(Color.white)
		selected = soft_selected.pop_front()
		selected.set_outline_color(globals.get("color_dark_green"))
		selected.select_lock(true)
	elif event.is_action_released("command") and selected:
		var character = selected.get_parent()
		if not character.has_method("execute_command"): return
		# these should all send commands
		character.clear_commands()
		var command = Command.new()
		if soft_selected.empty():
			# CHARACTER MOVE COMMAND
			command = get_command_move(get_global_mouse_position())
			character.execute_command(command)
		else:
			# CHARACTER INTERACT COMMAND
			# AUTOMATICALLY MOVES FIRST
			var target = soft_selected[0]
			if character.get_global_position().distance_to(target.get_global_position()) > character.INTERACT_RANGE:
				character.move_threshold = character.INTERACT_RANGE
				character.add_command(get_command_move(target.get_global_position()))
			command.action_name = "interact"
			command.next_state = "interacting"
			command.set_parameter("interact_target", target)
			character.add_command(command)

func get_command_move(move_target : Vector2):
	var command = Command.new()
	command.action_name = "move"
	command.next_state = "moving"
	command.parameters = {
		"move_target" : move_target
		}
	return command

func _on_mouse_over(set, interactable_node):
	if set:
		soft_selected.append(interactable_node)
	else:
		interactable_node.deselect()
		soft_selected.erase(interactable_node)
	update_soft_select()

func update_soft_select():
	if soft_selected.empty(): return
	if soft_selected.size() == 1:
		soft_selected[0].select()
		return
	soft_selected[0].deselect()
	soft_selected.sort_custom(self, "sort_by_position")
	soft_selected[0].select()

static func sort_by_position(a, b):
	if a.global_position.y > b.global_position.y:
		return true
	return false

class Command:
	
	var action_name : String
	var next_state : String
	var parameters  = {}
	
	func set_parameter(_name : String, _val):
		parameters[_name] = _val