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
		if not character.has_method("command"): return
		if soft_selected.empty():
			character.move_target = get_global_mouse_position()
		else:
			var target = soft_selected[0]
			character.interact_with(target)

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