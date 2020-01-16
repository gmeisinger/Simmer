extends Node2D

var notification_scene = preload("res://Scenes/Notification/notification.tscn")

export var dark = true

func _ready():
	globals.set("cur_scene", self)
	SignalMgr.register_subscriber(self, "notify", "notify")
	
func add_object(obj):
	$objects.add_child(obj)

func notify(pos : Vector2, text : String):
	var notification = notification_scene.instance()
	notification.notify(pos, text)
	add_child(notification)

func get_nav(pointA, pointB):
	#first get closest nav points
	var destination = pointB
	pointA = $map/nav.get_closest_point(pointA)
	pointB = $map/nav.get_closest_point(pointB)
	var path = $map/nav.get_simple_path(pointA, pointB)
	#if destination != pointB:
	#	path.append(destination)
	#print(path)
	return path