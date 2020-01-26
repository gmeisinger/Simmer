extends Control

var target = null
var entry_template

func _ready():
	entry_template = get_node("panel/entries/entry")
	remove_child(entry_template)

func add_entry(key : String, val : String):
	var new_entry = entry_template.duplicate()
	new_entry.get_node("key").set_text(key)
	new_entry.get_node("val").set_text(val)
	$panel/entries.add_child(new_entry)

func clear():
	for entry in $panel/entries.get_children():
		$panel/entries.remove_child(entry)

func set_target(new_target):
	if not new_target:
		target = null
		hide()
	else:
		target = weakref(new_target)
		set_info(target.get_ref())
		$panel.rect_size = $panel.rect_min_size
		show()

func update_info():
	if not target.get_ref():
		target = null
		hide()
		return
	else:
		pass

func  set_info(obj):
	clear()
	add_entry("Name", obj.get_object_name())
	add_entry("Type", obj.object_type)
	#var props = obj.get_property_list()
	match(obj.object_type):
		"character":
			add_entry("Team", obj.team_name)
			var hostile = TeamMgr.is_hostile("player", obj.team_name)
			if hostile:
				add_entry("Hostile", "Yes")
			add_entry("State", obj.get_state())
		"item":
			pass