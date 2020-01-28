extends "res://Scenes/StateMachine/baseState.gd"

func enter():
	#host.clear_commands()
	host.command_queue.clear()
	var path = globals.get("cur_scene").get_nav(host.global_position, host.move_target)
	#print(path)
	for i in range(1, path.size()-1):
		var move_comm = Command.get_move_command(path[i], 0.0)
		host.queue_command(move_comm)
	var move_comm = Command.get_move_command(host.move_target, 1.0)
	host.queue_command(move_comm)
	if not host.command_queue.empty():
		host.execute_command(host.command_queue.pop_front())
	else:
		var comm = Command.get_move_command(host.move_target, 1.0)
		host.execute_command(comm)