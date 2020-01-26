extends "res://Scenes/Items/BaseClasses/item.gd"

"""
Base class for weapons

George Meisinger 2019
"""

var attack_ready = true
var equipped = false

export var damage : float = 1.0

export var handle_offset : Vector2
export var two_handed : bool = false

onready  var anim = $AnimationPlayer

func initialize():
	$Sprite.position = handle_offset
	$Sprite.frame = 0

func get_info():
	var info = .get_info()
	info["damage"] = damage
	info["type"] = "weapon"
	info["equipped"] = equipped
	return info

func primary_fire(target : Vector2):
	pass
	
func secondary_fire(target : Vector2):
	pass

func set_enemy(enemy = true):
	pass

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
		
# Animation
func play_anim(anim_name):
	if anim.current_animation != anim_name:
		anim.play(anim_name)
		
#