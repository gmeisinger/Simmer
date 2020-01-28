extends RayCast2D

onready var host = get_parent()

func _draw():
	draw_line(position, position + cast_to, Color.black, 3.0)
	
func _process(delta):
	update()