extends Node

"""
THE TEAM MANAGER

keeps track of all the 'teams' in the game

uses a dict(teamname -> Team)

the Team object holds:
	a reference to each member
	a color
	some data regarding other team relations

a player team will need to be set up asap

while testing, the teams will be player vs all others
	a third team will be added afterward

FUNCTIONS:
	is_hostile(team_a, team_b)
		this will be used to check bullet collisions (we'll see)
"""

const HOSTILITY_THRESHOLD = -50.0

var teams = {}

func get_team(team_name : String):
	return teams[team_name]

func create_team(t_name, t_color):
	if teams.has(t_name):
		return
	var new_team = Team.new(t_name)
	new_team.set_team_color(t_color)
	teams[t_name] = new_team

func add_unit_to_team(unit, team_name : String):
	if not teams.has(team_name): return
	if team_name == "player":
		unit.set_player(true)
	else:
		unit.set_player(false)
	var new_team = teams.get(team_name)
	new_team.add_unit(unit)

func create_player_team(new_player):
	var p_team = Team.new("player")
	p_team.set_team_color(new_player.player_color)
	teams["player"] = p_team

func is_hostile(team_a : String, team_b : String):
	if not (teams.has(team_a) and teams.has(team_b)):
		return false
	if teams[team_a].get_stereotype(team_b) < HOSTILITY_THRESHOLD:
		return true
	else:
		return false

func reset():
	teams.clear()
#################################

class Team:
	
	# Team holds data to help with team management
	
	var team_name : String
	var team_color : Color
	
	var unit_weakrefs = []
	
	# stereotypes maps team name to an opinion float, starting at 0.0
	var stereotypes = {}
	
	func _init(_team_name : String):
		team_name = _team_name
	
	func set_team_color(col : Color):
		team_color = col
	
	func add_unit(unit):
		unit.set_shirt_color(team_color)
		unit_weakrefs.append(weakref(unit))
	
	func update_units(unit_list):
		unit_weakrefs.clear()
		for unit in unit_list:
			unit_weakrefs.append(weakref(unit))
	
	# Get the general opinion of another team
	func get_stereotype(other_team : String):
		if stereotypes.has(other_team):
			return stereotypes.get(other_team)
		else:
			stereotypes[other_team] = 0.0
			return 0.0
	
	func modify_stereotype(other_team : String, change : float):
		if stereotypes.has(other_team):
			stereotypes[other_team] = stereotypes.get(other_team) + change
		else:
			stereotypes[other_team] = change
