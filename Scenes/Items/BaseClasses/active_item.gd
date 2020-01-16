extends "res://Scenes/Items/BaseClasses/equippable.gd"

#export var damage : float = 1.0
export var handle_offset : Vector2
export var two_handed : bool = false

var enemy = false

var ready = true

onready var anim = $AnimationPlayer

#

func primary(target : Vector2):
	pass
	
func secondary(target : Vector2):
	pass

func set_enemy(enemy = true):
	pass

#

func flip(face : int):
	if face == -1:
		$Sprite.flip_v = true
		$Sprite.set_position( -1 * handle_offset)
		for pt in $Sprite.get_children():
			pt.position.y = abs(pt.position.y)
		for hand in $hands.get_children():
			hand.position.y = abs(hand.position.y)
	elif face == 1:
		$Sprite.flip_v = false
		$Sprite.set_position(Vector2(-1,1) * handle_offset)
		for pt in $Sprite.get_children():
			pt.position.y = abs(pt.position.y) * -1
		for hand in $hands.get_children():
			hand.position.y = abs(hand.position.y) * -1

func play_anim(anim_name, speed = 1.0):
	if anim.current_animation != anim_name:
		anim.play(anim_name, -1, speed)
		

func _on_cooldown_timeout():
	pass # Replace with function body.
