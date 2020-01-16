extends KinematicBody2D

# Fashion vars
export var shirtColor : Color = Color("891e2b")
export var pantsColor : Color = Color("5d2c28")
export var hairColor : Color = Color("000000")

#physics vars
var velocity = Vector2()
var h_face = 1
var v_face = "down"
var acceleration = 0.5
var max_speed = 2.0
var friction = 1.5
var tracking_target = false

func _ready():
	$shirt.self_modulate = shirtColor
	$pants.self_modulate = pantsColor
	$hair.self_modulate = hairColor



# Movement
func process_movement(delta):
	pass
	
func get_target():
	pass

func process_move_and_collide(delta):
	var collision_data = move_and_collide(velocity)
	return collision_data

func face_sprites(x, y):
	face_sprites_x(x)
	face_sprites_y(y)

func face_sprites_x(hface):
	var flip = false
	if hface == -1:
		flip = true
	elif hface == 1:
		flip = false
	else:
		return
	$body.flip_h = flip
	$shirt.flip_h = flip
	for armor in $shirt.get_children():
		armor.flip(flip)
	$pants.flip_h = flip
	for armor in $pants.get_children():
		armor.flip(flip)
	$hair.flip_h = flip
	for armor in $hair.get_children():
		armor.flip(flip)
	$hands.flip(hface)

func face_sprites_y(vface):
	if vface == 1:
		move_child(get_node("hands"), 4)
		v_face = "down"
	elif vface == -1:
		move_child(get_node("hands"), 0)
		v_face = "up"

func apply_friction(delta):
	velocity -= velocity * friction * delta

# Combat
func primary_fire(target : Vector2):
	pass

func take_bullet(bullet):
	pass

func die():
	pass

# Equipment

func equip(equipment):
	var removed
	match(equipment.slot):
		"armor":
			if $shirt.get_child_count() > 0:
				removed = unequip("armor")
			$shirt.add_child(equipment)
			equipment.attach_to_host($shirt)
		"helmet":
			if $hair.get_child_count() > 0:
				removed = unequip("helmet")
			$hair.add_child(equipment)
			equipment.attach_to_host($hair)
		"weapon":
			removed = $hands.equip_weapon(equipment)
	return removed

func unequip(slot):
	var removed
	match(slot):
		"armor":
			removed = $shirt.get_child(0)
			$shirt.remove_child(removed)
			$shirt.self_modulate = shirtColor
		"helmet":
			removed = $hair.get_child(0)
			$hair.remove_child(removed)
			$hair.self_modulate = hairColor
		"weapon":
			removed = $hands.unequip_weapon()
	return removed

func has_weapon():
	if $hands/held.get_child_count() > 0:
		return true
	else:
		return false

func get_weapon():
	return $hands/held.get_child(0)

func get_items():
	pass

# Fashion
func set_hair(tex):
	$hair.set_texture(tex)

func set_shirt(tex):
	$shirt.set_texture(tex)

func set_pants(tex):
	$pants.set_texture(tex)

func set_hair_color(col):
	$hair.self_modulate = col

func set_shirt_color(col):
	$shirt.self_modulate = col

func set_pants_color(col):
	$pants.self_modulate = col

# Animation
func play_anim(anim_name, speed : float = 1.0):
	var seek = $hands.play_anim(anim_name)
	if anim_name == "idle" or anim_name == "walk":
		anim_name += "_" + v_face
	if $AnimationPlayer.current_animation != anim_name:
		$AnimationPlayer.play(anim_name, -1, speed)
		if seek:
			$AnimationPlayer.seek(seek, true)
		
func anim_playing():
	return $AnimationPlayer.is_playing()

func _on_hitbox_area_entered(area):
	pass # Replace with function body.
