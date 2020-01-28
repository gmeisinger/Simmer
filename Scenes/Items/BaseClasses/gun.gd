extends "res://Scenes/Items/BaseClasses/active_item.gd"

export var attack_range = 500.0
export var minimum_range = 100.0
export var damage : float
export var fire_rate : float = 0.05
export(float, 0.0, 1.0, 0.01) var accuracy = 1.0 #perfect accuracy
export(float, 0.0, 1.0, 0.01) var recoil
export(String, FILE, "*.tscn") var bullet_scene
export var burst_count = 3
export var burst_delay = 1.0

var bullet

func _ready():
	bullet = load(bullet_scene)

func primary(target : Vector2):
	target = apply_accuracy(target, accuracy)
	shoot(target)

# Uses a value between 0.0 and 1.0 to adjust the target point randomly
func apply_accuracy(target : Vector2, _accuracy : float):
	_accuracy = 0.8 + (0.2 * _accuracy)
	var angle = target.angle()
	var mod = 1.0 - _accuracy
	var new_angle_min = angle - (0.5 * (mod * PI))
	var new_angle_max = angle + (0.5 * (mod * PI))
	var new_angle = rand_range(new_angle_min, new_angle_max)
	var new_target = Vector2(cos(new_angle), sin(new_angle)) * target.length()
	return new_target

func shoot(target : Vector2):
	play_anim("fire")
	ready = false
	var new_bullet = bullet.instance()
	target = apply_accuracy(target, accuracy)
	new_bullet.init(damage, enemy)
	new_bullet.set_team(team_name)
	new_bullet.cur_owner = weakref(get_cur_owner())
	globals.get("cur_scene").add_object(new_bullet)
	new_bullet.position = $"Sprite/fire_point".global_position
	new_bullet.fire(target)
	$cooldown.start(fire_rate)

func _on_cooldown_timeout():
	ready = true