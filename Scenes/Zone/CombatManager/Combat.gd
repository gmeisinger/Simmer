extends Node

"""
Represents a 'fight'

units can join fights by attacking a target

cases:
	
	1) both units not in combat:
		a new combat is created
		{ 
		'team1' : [unit1],
		'team2' : [unit2]
		}
		
	2) 1 unit is in combat:
		the unit NOT in combat is added to the existing combat
	
	3) both units in same combat:
		switch target
	
	4) both units in seperate combats:
		combats should be JOINED?
"""

# Master map of team_name -> unit list
var combatants = {}

func get_combatants():
	return combatants

func get_teams():
	return combatants.keys()

func get_combatants_on_team(team_name : String):
	var ref_list = []
	var unit_list = []
	if combatants.has(team_name):
		ref_list =  combatants[team_name]
	else:
		return []
	for wr in ref_list:
		if wr.get_ref():
			unit_list.append(wr.get_ref())
		else:
			combatants.erase(wr)
	return unit_list

func add_combatant(character):
	var char_wr = weakref(character)
	var team = character.team_name
	if combatants.keys().has(team):
		combatants[team].append(char_wr)
		var debug = "added " + character.name + " to combat " + name
		print(debug)
	else:
		combatants[team] = [char_wr]
		var debug = "added " + character.name + " to new team in combat " + name
		print(debug)
	character.combat_id = name
	character.enter_combat()

func remove_team(t_name):
	combatants.erase(t_name)
	var dissolve = true
	for team in combatants.keys():
		if not get_combatants_on_team(team).empty():
			dissolve = false
	if dissolve:
		#var msg = name + " dissolving..."
		#print(msg)
		queue_free()
