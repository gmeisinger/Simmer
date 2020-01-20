extends CanvasLayer

const ITEM_WIDTH = 96.0
const ITEM_HEIGHT = 16.0

signal item_selected(action_text)

onready var menu = $menu
onready var player = get_parent()

func display(pos : Vector2, choices : Array):
	if choices.empty(): return
	menu.clear()
	var pop_rect = Rect2()
	pop_rect.position = pos
	pop_rect.size.x = ITEM_WIDTH
	pop_rect.size.y = ITEM_HEIGHT * choices.size()
	for choice in choices:
		menu.add_item(choice)
	menu.popup(pop_rect)

func get_item_text(idx : int):
	return menu.get_item_text(idx)

func _on_menu_index_pressed(index):
	var text = get_item_text(index)
	emit_signal("item_selected", text)
