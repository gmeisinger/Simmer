extends Node2D

const UPDATE_TIME = 0.3

signal objects_sighted(objs)

export var sight_active = true


var in_sight = []
var hidden = []

func check_los(areas):
	if sight_active:
		hidden.clear()
		in_sight.clear()
		for area in areas:
			var obj = area.get_parent().get_host()
			$RayCast2D.set_cast_to(obj.global_position - global_position)
			if $RayCast2D.is_colliding():
				hidden.append(obj)
			else:
				in_sight.append(obj)
		if not in_sight.empty():
			#print("objects in los!")
			emit_signal("objects_sighted", in_sight)
		
func _on_update_timer_timeout():
	check_los($Area2D.get_overlapping_areas())
	$update_timer.start(UPDATE_TIME)



