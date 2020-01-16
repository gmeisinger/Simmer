extends "res://Scenes/StateMachine/baseState.gd"

var target : Vector2
var speed : float
var distance = 0.0
var target_dist : float
var kin_body : KinematicBody2D

func enter():
	# enable collision
	kin_body = host.get_node("collision")
	kin_body.show()
	if host.fetchable:
		host.get_node("interactable").set_collision_layer_bit(globals.get_layer("fetchables"), true)
		host.get_node("interactable").set_active(true)
	target = host.global_target
	distance = 0.0
	target_dist = host.throw_dist
	print(target_dist)
	pass

func update(delta):
	# update position
	var col = kin_body.move_and_collide(host.velocity)
	if col:
		distance = target_dist
	host.position = kin_body.global_position
	kin_body.position = Vector2.ZERO
	distance += host.velocity.length()
	host.rotation_degrees += 2
	if distance > target_dist:
		#here i could use a tween to make the item "skid"
		#then on the _on_tween_complete signal make it a pickup
		host.change_state("pickup")
	pass

func exit():
	# disable collision
	kin_body.hide()
	if host.fetchable:
		host.get_node("interactable").set_collision_layer_bit(globals.get_layer("fetchables"), false)
		host.get_node("interactable").set_active(false)
	pass