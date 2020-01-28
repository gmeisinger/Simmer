extends "res://Scenes/StateMachine/baseState.gd"

var pathfinding = false
var saved_move_threshold
var colliding = false

func enter():
	if not host.check_focus():
		change_state(host.default_state)
		return
	pathfinding = false
	saved_move_threshold = host.move_threshold

func update(delta):
	if not host.check_focus():
		change_state(host.default_state)
		return
	if host.global_position.distance_to(host.focus_target.global_position) <= host.move_threshold:
		if host.check_los(host.focus_target.global_position):
			change_state(host.default_state)
			return
	if host.check_los(host.focus_target.global_position) and not colliding:
		pathfinding = false
		host.move_threshold = saved_move_threshold
		host.move_target = host.focus_target.global_position
	else:
		pathfinding = true
		host.move_threshold = 0.0
		host.move_target = get_nav_target()
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


func get_nav_target():
	var path = host.get_nav_path(host.focus_target.global_position)
	if path.size() <= 1:
		pathfinding = false
		host.move_threshold = saved_move_threshold
		return host.global_position
	elif path[0] == host.global_position:
		if path.size() == 2:
			pathfinding = false
			host.move_threshold = saved_move_threshold
		return path[1]
	else:
		return path[0]