extends "res://Scenes/StateMachine/baseState.gd"

const TURN_TIMER = 4.0

var turn_ready = false

func enter():
	host.move_target = host.get_global_position()
	host.move_threshold = host.ARRIVAL_DISTANCE
	host.disable_focus()
	host.disable_interact()

func update(delta):
	if not host.command_queue.empty():
		host.execute_command(host.command_queue.pop_front())
	elif host.is_in_combat():
		host.emit_signal("character_no_target", host)
	elif turn_ready:
		turn_ready = false
		$turn_timer.start(TURN_TIMER)
		if randi() % 3 > 0:
			#turn
			host.velocity.x = host.h_face
	if host.velocity == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)



func _on_turn_timer_timeout():
	turn_ready = true
