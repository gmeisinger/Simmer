extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	if not host.check_focus():
		change_state(host.default_state)

func update(delta):
	if not host.check_focus():
		change_state(host.default_state)
		return
	host.move_target = host.focus_target.global_position
	if host.velocity == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)