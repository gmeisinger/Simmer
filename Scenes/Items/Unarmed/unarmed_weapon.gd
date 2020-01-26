extends "res://Scenes/Items/BaseClasses/active_item.gd"

var knockback = 0.01
var damage = 1


func primary_fire(target : Vector2):
	play_anim("fire")
	ready = false
	$hands/hand2/hitbox/shape.disabled = false

func destroy():
	$hands/hand2/hitbox/shape.disabled = true

func set_enemy(enemy = true):
	if enemy:
		$hands/hand2/hitbox.set_collision_layer_bit(3, false)
		$hands/hand2/hitbox.set_collision_layer_bit(4, true)
		$hands/hand2/hitbox.set_collision_mask_bit(2, false)
		$hands/hand2/hitbox.set_collision_mask_bit(1, true)
	else:
		$hands/hand2/hitbox.set_collision_layer_bit(3, true)
		$hands/hand2/hitbox.set_collision_layer_bit(4, false)
		$hands/hand2/hitbox.set_collision_mask_bit(2, true)
		$hands/hand2/hitbox.set_collision_mask_bit(1, false)
		

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fire":
		ready = true
		$hands/hand2/hitbox/shape.disabled = true
