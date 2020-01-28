extends Node2D

var notification_scene = preload("res://Scenes/Notification/notification.tscn")

export var player_start = Vector2(0.0, 0.0)

func _ready():
	globals.set("cur_scene", self)
	SignalMgr.register_subscriber(self, "notify", "notify")
	
func add_object(obj):
	$objects.add_child(obj)

func notify(pos : Vector2, text : String, color : Color = Color.white):
	var notification = notification_scene.instance()
	notification.notify(pos, text)
	notification.set_color(color)
	add_child(notification)

func closest_point(point : Vector2):
	return $map/nav.get_closest_point(point)

func get_nav(pointA, pointB):
	#first get closest nav points
	#var offset = $map/nav/navMap.get_cell_size() / 2.0
	var start = pointA
	pointA = $map/nav.get_closest_point(pointA)
	var destination = pointB
	pointB = $map/nav.get_closest_point(pointB)

	var path = $map/nav.get_simple_path(pointA, pointB)
	if destination != pointB:
		path.append(destination)
	#print(path)
	return path