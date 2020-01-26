extends Node

onready var Combat = load("res://Scenes/Zone/CombatManager/Combat.tscn")

onready var zone = get_parent()

"""
Keeps track of units in combat

UNITS and not their interactables ( right? )

example:
	
	- when attacking, a unit will enter a 'combat' with its target
	
	- the combat maps a team name to list of participants
	
	- if a third unit tries to enter combat:
		we check to see if the unit is already in combat
		if so, we add the new unit to the existing combat
	
	- when a target is killed/escapes, a unit in combat will look for a new target
		will only look at teams that are 'hostile'
		if there are no targets, the unit leaves combat
	
	- when parties are a thing, attacking a unit brings the whole party into combat
"""

func _ready():
	SignalMgr.register_subscriber(self, "character_died", "_on_character_died")
	SignalMgr.register_subscriber(self, "character_attacking", "enter_combat")
	SignalMgr.register_subscriber(self, "character_no_target", "_on_character_no_target")
	globals.set("CombatManager", self)

func enter_existing_combat(character, combat_id):
	print(character.name)
	var combat = get_node(combat_id)
	if not combat: return
	if character.is_in_combat(): return
	combat.add_combatant(character)
	_on_character_no_target(character)

# source character uses this to request combat with target
func enter_combat(source, target):
	if source.is_in_combat():
		if target.is_in_combat():
			if source.combat_id != target.combat_id:
				pass
				# get each combat
				# combine them
				# add new combat and remove old ones
		else:
			var combat = get_node(source.combat_id)
			#add target to source's combat
			combat.add_combatant(target)
			# since this guy wasnt in combat, he should attack
			_on_character_no_target(target)
	elif target.is_in_combat():
		var combat = get_node(target.combat_id)
		combat.add_combatant(source)
		# add source to target's combat
		# source targets 'target'
	else:
		#neither in combat, create a new one
		var new_combat = Combat.instance()
		add_child(new_combat)
		#add them both, attack eachother
		new_combat.add_combatant(source)
		new_combat.add_combatant(target)
		#target.react_to_action(source, "attack")
		_on_character_no_target(target)

func _on_character_no_target(character):
	var combat = get_node(character.combat_id)
	var targets = []
	if combat:
		for team in combat.get_teams():
			#print(team)
			if TeamMgr.is_hostile(character.get_team(), team):
				targets += combat.get_combatants_on_team(team)
				#print(targets)
		if targets.empty():
			#print("no targets!")
			for c in combat.get_combatants_on_team(character.get_team()):
				character.exit_combat()
			combat.remove_team(character.get_team())
		else:
			var target = targets[0]
			#var debug = target.name + " was chosen as new target"
			#print(debug)
			var comm = Command.get_attack_command(target)
			character.execute_command(comm)
	else:
		character.exit_combat()

# characters emit when they die, they send themself
# find character in combat and remove it
func _on_character_died(character):
	var combat = get_node(character.combat_id)