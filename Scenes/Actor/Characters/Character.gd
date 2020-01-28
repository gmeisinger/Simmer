extends "res://Scenes/Actor/actor.gd"

const ARRIVAL_DISTANCE = 10.0
const INTERACT_RANGE = 30.0

var object_type = "character"

signal arrived_at_move_target()
signal characer_dying(ref)
signal character_attacking(ref, target)
signal character_no_target(ref)
signal notify()

onready var unarmed_weapon = load("res://Scenes/Items/Unarmed/unarmed_weapon.tscn")

var command_queue = []

onready var move_threshold = ARRIVAL_DISTANCE

#target vars
onready var move_target = get_position()

# target refs have some safety vars...
var interact_target
var interact_target_wr
var interact_target_valid = false

var focus_target
var focus_target_wr
var focus_target_valid = false

var interact_action : String

var in_combat = false
var combat_id : String
var los_trigger_state = null

export var team_name : String

var next_state : String = ""

export var start_as_player = false
export var default_state : String = "idle"
export(String, FILE, "*.tscn") var starting_weapon
export(String, FILE, "*.tscn") var starting_armor
export(String, FILE, "*.tscn") var starting_helmet

func _ready():
	SignalMgr.register_publisher(self, "character_dying")
	SignalMgr.register_publisher(self, "character_attacking")
	SignalMgr.register_publisher(self, "character_no_target")
	SignalMgr.register_publisher(self, "notify")
	SignalMgr.register_subscriber(self, "pause_game", "_on_pause")
	set_player(start_as_player)
	var equip_scn
	var equip
	if starting_weapon:
		equip_scn = load(starting_weapon)
		equip = equip_scn.instance()
		$inventoryMgr.equip(equip)
	if starting_armor:
		equip_scn = load(starting_armor)
		equip = equip_scn.instance()
		$inventoryMgr.equip(equip)
	if starting_helmet:
		equip_scn = load(starting_helmet)
		equip = equip_scn.instance()
		$inventoryMgr.equip(equip)
	#equip_fists()

func get_interactable():
	return $interactable

func get_state():
	return $stateMachine.current_state.name

func process_movement(delta):
	move_target = globals.get("cur_scene").closest_point(move_target)
	if position.distance_to(move_target) > move_threshold:
		var delta_vel = position.direction_to(move_target) * acceleration * delta
		velocity += delta_vel
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	elif velocity != Vector2.ZERO:
		velocity = velocity / 3.0
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
			emit_signal("arrived_at_move_target")
			#$stateMachine.change_state(default_state)
	var v_face = sign(velocity.y)
	var new_sightcone_rotation = $SightCone.get_rotation()
	if focus_target:
		h_face = sign(global_position.direction_to(focus_target.global_position).x)
		v_face = sign(global_position.direction_to(focus_target.global_position).y)
		new_sightcone_rotation = Vector2.ZERO.angle_to(focus_target.global_position - global_position)
	elif velocity.x != 0.0:
		h_face = sign(velocity.x)
		new_sightcone_rotation = velocity.angle()
	face_sprites(h_face, v_face)
	$SightCone.rotate_to_angle(new_sightcone_rotation)

# Command Methods

func queue_command(new_command):
	command_queue.append(new_command)

func execute_command(new_command):
	for key in new_command.parameters.keys():
		set(key, new_command.parameters[key])
	$stateMachine.change_state(new_command.next_state)

func clear_commands():
	command_queue.clear()
	$stateMachine.change_state("idle")

# THIS MEANS TO INTERACT WITH THE TARGET
func interact_with(target, action_name : String):
	if not target.has_method("interact"):
		return
	target.interact(self, action_name)

# THIS MEANS TO BE INTERACTED WITH BY THE TARGET
func interact(source, selected_action : String):
	say("Hello! Don't fuck with me!")


# this allows a character to react to an action that targets them
func react_to_action(source, act_name : String):
	var state = $stateMachine.current_state.name
	if state != "idle": return
	match(act_name):
		"attack":
			if has_weapon():
				var attack_command = Command.get_attack_command(source)
				execute_command(attack_command)
			else:
				#flee
				pass
		_:
			pass

func say(msg):
	$SpeechBubble.say(msg)

func get_nav_path(point : Vector2):
	var path = globals.get("cur_scene").get_nav(global_position, point)
		#print("really close to first position")
	var final_path = PoolVector2Array()
	for i in range(1, path.size()):
		if global_position.distance_to(path[i]) > move_threshold:
			final_path.append(path[i])
	return final_path

func get_target():
	var target_vec = Vector2(h_face * 100.0, 0.0)
	if check_focus():
		target_vec = focus_target.global_position - global_position
	return target_vec

func check_los(point : Vector2):
	$LOS.cast_to = point - global_position
	$LOS.force_raycast_update()
	#$LOS.enabled = true
	return !$LOS.is_colliding()
	

func check_focus():
	var valid = false
	if focus_target_valid:
		#it was set at some point
		if focus_target_wr.get_ref():
			#weakref was setup
			if focus_target:
				valid = true
	return valid

func check_interact():
	var valid = false
	if interact_target_valid:
		#it was set at some point
		if interact_target_wr.get_ref():
			#weakref was setup
			if interact_target:
				valid = true
	return valid

func disable_focus():
	focus_target = null
	focus_target_valid = false

func disable_interact():
	interact_target = null
	interact_target_valid = false

func set_player(set : bool):
	$interactable.set_player(set)
	if set:
		if not globals.get("player"):
			print("player needs to load before units")
			return
		team_name = "player"
		var new_color = globals.get("player").player_color
		new_color.r -= 0.1
		new_color.b -= 0.1
		new_color.g -= 0.1
		set_shirt_color(new_color)
	else:
		set_shirt_color(shirtColor)

func is_player():
	return $interactable.get_node("area").get_collision_layer_bit(1)
# Equipment functions

func equip_fists():
	var fists = unarmed_weapon.instance()
	if has_weapon():
		$inventoryMgr.unequip(get_weapon())
	$inventoryMgr.equip(fists)

# Combat functions
func damage(amt : float):
	$StatBlock.damage(amt)

func heal(amt : float):
	$StatBlock.heal(amt)

func attack(target : Vector2):
	if not has_weapon(): return
	get_weapon().primary(target)

func take_bullet(bullet):
	damage(bullet.damage)
	velocity = bullet.velocity * bullet.knockback
	bullet.destroy()
	if not is_in_combat() and bullet.cur_owner.get_ref():
		react_to_action(bullet.cur_owner.get_ref(), "attack")
		say("Ouch, fucker!")
		# attack whoever shot me

func enter_combat():
	in_combat = true
	$SightCone.sight_active = false

func exit_combat():
	in_combat = false
	$SightCone.sight_active = true

func is_in_combat():
	return in_combat

func get_team():
	return team_name

func set_team(t_name : String):
	team_name = t_name

# triggered by bullets in hitbox
func _on_hitbox_area_entered(area):
	var bullet = area.get_parent()
	if TeamMgr.is_hostile(bullet.get_team(), team_name):
		take_bullet(bullet)

#Death

func die():
	emit_signal("character_dying", self)
	# drop stuff
	$inventoryMgr.drop_all_items()
	# check interactable
	if $interactable.active:
		$interactable.emit_signal("mouse_over", false, $interactable)
		$interactable.set_active(false)
		globals.get("player").update_mouse_hover()
		globals.get("player").hard_selected.erase($interactable)
		yield(get_tree().create_timer(0.1), "timeout")
	queue_free()

func _on_StatBlock_zero_health():
	$stateMachine.change_state("dying")

func _on_pause(pause):
	$stateMachine.disabled = pause
	if pause:
		$AnimationPlayer.stop(false)
	
func _on_update_sight_cone(objs):
	if in_combat: return
	for obj in objs:
		match(obj.object_type):
			"character":
				if obj.is_in_combat():
					var combat = obj.combat_id
					globals.get("CombatManager").enter_existing_combat(self, combat)
					emit_signal("notify", global_position, "!", Color.red)
			"item":
				pass
			_:
				pass
