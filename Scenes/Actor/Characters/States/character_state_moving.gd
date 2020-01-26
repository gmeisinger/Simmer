extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	host.disable_focus()
	host.disable_interact()

func update(delta):
	if host.velocity == Vector2.ZERO:
		host.play_anim("idle")
	else:
		host.play_anim("walk")
	host.process_movement(delta)
	host.process_move_and_collide(delta)
	
func _on_Character_arrived():
	change_state("idle")