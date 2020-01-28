extends "res://Scenes/StateMachine/baseState.gd"

const BASE_STRAFE_TIME = 1.0
const STATE_LOCK_TIME = 1.5

var burst_counter = 0
var attack_ready = true
var ready_to_start = false


var left = true

var weapon

var colliding = false

onready var state_lock_counter = 0.0

#var target_wr : WeakRef

func enter():
	ready_to_start = false
	host.command_queue.clear()
	# check for weapon, focus target
	if not host.has_weapon() or not host.check_focus():
		change_state("idle")
		return
	elif not is_in_range():
		# need to approach
		queue_approach()
		return
	elif not host.check_los(host.focus_target.global_position):
		print("no los queue approach")
		queue_approach()
		return
	#reset vars
	ready_to_start = true
	state_lock_counter = 0.0
	#host.in_combat = true
	host.emit_signal("character_attacking", host, host.focus_target)
	#host.focus_target.react_to_action(host, "attack")
	burst_counter = 0
	attack_ready = true
	weapon = host.get_weapon()
	$strafe_timer.start(BASE_STRAFE_TIME)

func update(delta):
	if ready_to_start:
		state_lock_counter += delta
		if not host.check_focus():
			host.emit_signal("character_no_target", host)
			change_state("idle")
			return
		#if not target_wr.get_ref():
		#	change_state(host.default_state)
		if not is_in_range():
			host.move_target = host.global_position + ((get_nav_target() - host.global_position).normalized() * 100.0)
		elif not host.check_los(host.focus_target.global_position) or colliding:
			host.move_target = host.global_position + ((get_nav_target() - host.global_position).normalized() * 100.0)
		elif host.global_position.distance_to(host.focus_target.global_position) < host.get_weapon().minimum_range:
			host.move_target = host.global_position + (get_backward_normal() * 100.0)
		else:
			# Strafe movement
			host.move_target = host.global_position + (get_tangent_normal() * 100.0)
		if attack_ready:
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
		
		# Handle physics
		if host.velocity == Vector2.ZERO:
			host.play_anim("idle")
		else:
			host.play_anim("walk")
		host.process_movement(delta)
		var collision = host.process_move_and_collide(delta)
		if collision:
			colliding = true
		else:
			colliding = false

func exit():
	print("leaving attack state")

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
	
func get_backward_normal():
	if not host.check_focus(): return
	var angle = (host.global_position.direction_to(host.focus_target.global_position) * -1).angle()
	var normal = Vector2(cos(angle), sin(angle))
	return normal.normalized()

func queue_approach():
	var approach_range = host.get_weapon().attack_range * 0.8
	var approach_comm = Command.get_approach_command(host.focus_target, approach_range)
	var attack_comm = Command.get_attack_command(host.focus_target)
	host.queue_command(approach_comm)
	host.queue_command(attack_comm)
	change_state("idle")

func get_nav_target():
	var path = host.get_nav_path(host.focus_target.global_position)
	if path.size() <= 1:
		return host.global_position
	elif path[0] == host.global_position:
		return path[1]
	else:
		return path[0]

func _on_attack_timer_timeout():
	attack_ready = true


func _on_strafe_timer_timeout():
	var roll = randi() % 4
	if roll > 0:
		left = !left
	var new_time = rand_range(0.8, 1.2) * BASE_STRAFE_TIME
	$strafe_timer.start(new_time)
