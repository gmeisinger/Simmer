extends Node

# Autoload singleton manages loading larger game scenes with a progress bar
# (WorldMap, Levels, SubLevels?)
# To test it out put some large images (10MB+) as sprites in levels/<tscn>
# then load it from the world map
# with enough load stages you'll see a progress bar

onready var _ui : Control = $"Control"
onready var _progress_bar : ProgressBar = $"Control/ProgressBar"

const TIME_MAX = 100

var _wait_frames: int
var _loader : ResourceInteractiveLoader
var _current_scene : Node

func _ready():
	_ui.hide()

func load_scene(scene_path):
	_loader = ResourceLoader.load_interactive(scene_path)
	set_process(true)
	_ui.show()
	_current_scene.queue_free()
	_wait_frames = 1

func _process(delta):
	if _loader == null:
		set_process(false)
		return
	if _wait_frames > 0: # wait for frames to let the "loading" animation show up (using progress bar for now)
		_wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + TIME_MAX: # how long we block this thread
		var err = _loader.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = _loader.get_resource()
			_loader = null
			_set_new_scene(resource)
			break
		elif err == OK:
			_update_progress()
			break
		else: # error during loading
			_show_error()
			_loader = null
			break

func _update_progress():
	_progress_bar.set_value(float(_loader.get_stage()) / _loader.get_stage_count())

func _set_new_scene(scene_resource):
	_progress_bar.set_value(0)
	_ui.hide()
	_current_scene = scene_resource.instance()
	get_node("/root").add_child(_current_scene)

func _show_error():
	print('Dang... something went wrong!')
