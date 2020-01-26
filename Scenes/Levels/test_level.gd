extends "res://Scenes/Zone/zone.gd"

onready var char_scene = load("res://Scenes/Actor/Characters/Character.tscn")

func _ready():
	# setup teams
	TeamMgr.reset()
	TeamMgr.create_player_team($Player)
	TeamMgr.create_team("Others", globals.get("color_dark_gray"))
	TeamMgr.get_team("player").modify_stereotype("Others", -100.0)
	TeamMgr.get_team("Others").modify_stereotype("player", -100.0)
	var fashion_dict = globals.get("player_fashion")
	if fashion_dict:
		var new_pc = char_scene.instance()
		new_pc.start_as_player = true
		new_pc.name = fashion_dict["player_name"]
		add_object(new_pc)
		new_pc.set_hair(fashion_dict["hair"])
		new_pc.set_hair_color(fashion_dict["hair_color"])
		new_pc.set_shirt_color(fashion_dict["shirt_color"])
		new_pc.set_pants_color(fashion_dict["pants_color"])
	for unit in $objects/starting_units.get_children():
		if unit.start_as_player or unit.team_name == "player":
			TeamMgr.add_unit_to_team(unit, "player")
		elif unit.team_name:
			TeamMgr.add_unit_to_team(unit, unit.team_name)
		else:
			unit.team_name = "none"
	# give jerry a gun
	"""
	var ak_scene = load("res://Scenes/Items/Final/assault_rifle.tscn")
	var jerrys = [ $objects/starting_units/Jerry, $objects/starting_units/Jerry2, $objects/starting_units/Jerry3 ]
	for j in jerrys:
		var new_ak = ak_scene.instance()
		add_object(new_ak)
		new_ak.interact(j, "Equip")
	"""