extends "res://Scenes/StateMachine/baseState.gd"

const BASE_STRAFE_TIME = 1.0

var burst_counter = 0
var attack_ready = true

var left = true

var weapon

#var target_wr : WeakRef

func enter():
	# check for weapon, focus target
	if not host.has_weapon() or not host.check_focus():
		change_state("idle")
		return
	elif not is_in_range():
		# need to approach
		queue_approach()
		return
	#reset vars
	#host.in_combat = true
	host.emit_signal("character_attacking", host, host.focus_target)
	#host.focus_target.react_to_action(host, "attack")
	burst_counter = 0
	attack_ready = true
	weapon = host.get_weapon()
	$strafe_timer.start(BASE_STRAFE_TIME)

func update(delta):
	if not host.check_focus():
		host.emit_signal("character_no_target", host)
		change_state("idle")
		return
	#if not target_wr.get_ref():
	#	change_state(host.default_state)
	if not is_in_range():
		queue_approach()
		return
	elif attack_ready:
		attack_ready = false
		var local_target = host.focus_target.global_position - host.global_position
		host.attack(local_target)
		burst_counter += 1
		if burst_counter >= weapon.burst_count:
			# burst over
			burst_counter = 0
			$attack_timer.start(weapon.burst_delay)
		else:
			$attack_timer.start(weapon.fire_rate)
	# Strafe movement
	host.move_target = host.global_position + (get_tangent_normal() * 100.0)
	# Handle physics
	if host.velocity == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)

func exit():
	pass

func is_in_range():
	if host.check_focus() and host.global_position.distance_to(host.focus_target.global_position) > host.get_weapon().attack_range:
		return false
	return true

func get_tangent_normal():
	if not host.check_focus(): return
	var direct_angle = host.global_position.direction_to(host.focus_target.global_position).angle()
	var offset = PI/2.0
	var angle = direct_angle + offset
	if left:
		angle = direct_angle - offset
	var normal = Vector2(cos(angle), sin(angle))
	return normal.normalized()

func queue_approach():
	var approach_range = host.get_weapon().attack_range * 0.8
	var approach_comm = Command.get_approach_command(host.focus_target, approach_range)
	var attack_comm = Command.get_attack_command(host.focus_target)
	host.queue_command(approach_comm)
	host.queue_command(attack_comm)
	change_state("idle")

func _on_attack_timer_timeout():
	attack_ready = true


func _on_strafe_timer_timeout():
	left = !left
	$strafe_timer.start(BASE_STRAFE_TIME)
