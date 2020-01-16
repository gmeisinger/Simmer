extends Node2D

enum { EMPTY, ONE, TWO }

var state = EMPTY

onready var weapon_pos = $held.position
onready var host = get_owner()

func _ready():
	pass

func get_equipped_weapon():
	if $held.get_child_count() > 0:
		return $held.get_child(0)
	else:
		return null

func play_anim(anim_name):
	if anim_name == "dodge":
		visible = false
		return
	match(state):
		EMPTY:
			continue
		ONE:
			anim_name += "_1h"
		TWO:
			anim_name = "2h"
	if !$AnimationPlayer.has_animation(anim_name):
		visible = false
		return
	else:
		visible = true
	if $AnimationPlayer.current_animation != anim_name:
		$AnimationPlayer.play(anim_name)
	return $AnimationPlayer.get_current_animation_position()

func flip(face : int):
	if face == -1:
		$Sprite.flip_h = true
	elif face == 1:
		$Sprite.flip_h = false
	#if state == TWO:
	#	face = 0
	$held.position.x = weapon_pos.x * face
	if $held.get_child_count() > 0:
		$held.get_child(0).flip(face)

func point_at(pt : Vector2):
	#find vector from (0, weapon_pos.y) to pt
	# target location is vec.normalized * weapon_pos.x
	#move $weapon to location
	#rotate $weapon to vec.normalized
	var direction = Vector2(0, weapon_pos.y).direction_to(pt)
	var new_position = direction * weapon_pos.length()
	new_position.y = (new_position.y / 2.0) + (weapon_pos.y / 1.5)
	$held.set_position(new_position)
	$held.rotation = direction.angle()

func get_target():
	return host.get_target()

func equip_weapon(weapon):
	var old_weapon
	if $held.get_child_count() > 0:
		old_weapon = unequip_weapon()
	if weapon.two_handed:
		change_state("2h")
	else:
		change_state("1h")
	$held.add_child(weapon)
	return old_weapon

func unequip_weapon():
	var old_weapon = $held.get_child(0)
	$held.remove_child($held.get_child(0))
	change_state("empty")
	return old_weapon

func change_state(state : String):
	$stateMachine.change_state(state)