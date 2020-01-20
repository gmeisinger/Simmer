extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.move_target = host.get_global_position()
	host.move_threshold = host.ARRIVAL_DISTANCE
	host.focus_target = null

func update(delta):
	if not host.command_queue.empty():
		host.execute_command(host.command_queue.pop_front())
	if host.velocity == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)