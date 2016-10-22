# scene_loader
## Example Implementation

```gdscript
############################################################
# SCENE LOADER
# Loads scenes and does all the nitty gritty work
# Dispatches 3 signals:
#	"START" when a scene begins loading, with the scene
#		path as an argument
#	"DONE" when a scene has loaded, with the scene resource
#		as an argument
#	"PROGRESS" as the scene loads, with the percentage
#		as an argument (as a value between 0 and 1)
#	"ERROR" when an error has occured, with the error as
#		an argument
#
# Useful methods:
#	- load_scene(string path): begins loading a scene
#	- free_current_scene(): removes the scene from the tree
#	- set_initial_scene(node scene): if you already have
#		a scene set through the editor, this will set it
#		as the current scene so it can be removed when
#		loading a new one
############################################################

static func instance(node):
	var loader = Loader.new()
	node.add_child(loader)
	return loader

class Loader extends Node:
	var current_scene
	var loader
	var wait_frames
	var time_max = 100
	var progress = 0
	var artificial_slow_down = false
	var artificial_slow_down_frames = 60
	var artificial_slow_down_current = 60
	var done = false
	
	signal DONE(scene_resource)
	signal ERROR
	signal PROGRESS(percent)
	signal START(scene_path)
	
	func slow_down(frames=60):
		artificial_slow_down = true
		artificial_slow_down_current = frames
		artificial_slow_down_frames = frames
	
	func free_current_scene():
		if current_scene && current_scene.get_ref():
			current_scene.get_ref().queue_free()
			
	func load_scene(path):
		emit_signal("START",path)
		progress = 0
		done = false
		loader = ResourceLoader.load_interactive(path)
		
		if loader == null:
			show_error("scene at "+path+" could not be loaded")
			return
			
		free_current_scene()
		wait_frames = 1
	
		set_process(true)
		
	func update_progress():
		if !done:
			progress = float(loader.get_stage()) / loader.get_stage_count()
		else:
			progress = 1
		emit_signal("PROGRESS",progress)
		
	func get_progress():
		return progress
		
	func get_stage():
		return loader.get_stage()
		
	func get_stage_count():
		return loader.get_stage_count()
		
	func set_new_scene(scene_resource):
		var scene_instance = scene_resource.instance()
		current_scene = weakref(scene_instance)
		done = true
		update_progress()
		emit_signal("DONE",scene_instance)
	
	func set_initial_scene(node):
		if node:
			current_scene = weakref(node)
		
	func get_scene():
		if current_scene && current_scene.get_ref():
			return current_scene.get_ref()
		
	func _process(time):
		if loader == null:
			set_process(false)
			return
		
		if wait_frames > 0:
			wait_frames -= 1
			return
		
		if artificial_slow_down:
			if artificial_slow_down_current:
				artificial_slow_down_current-=1
				return
			else:
				poll()
		else:
			var t = OS.get_ticks_msec()
			while OS.get_ticks_msec() < t + time_max:
				var stop = poll()
				if stop:
					break;
		
		artificial_slow_down_current = artificial_slow_down_frames
	
	func poll():
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			return true
		elif err == OK:
			update_progress()
			return false
		else:
			show_error(err)
			loader = null
			return true

	func show_error(err):
		var error_str = str(err)
		if errors.has(err):
			error_str = errors[err] + "("+str(err)+")"
		var message = "an error occured while loading the scene: " + error_str
		print(message)
		emit_signal("ERROR",error_str)
		
	var errors = {
		0: "OK",
		1: "FAILED",
		2: "ERR_UNAVAILABLE",
		3: "ERR_UNCONFIGURED",
		4: "ERR_UNAUTHORIZED",
		5: "ERR_PARAMETER_RANGE_ERROR",
		6: "ERR_OUT_OF_MEMORY",
		7: "ERR_FILE_NOT_FOUND",
		8: "ERR_FILE_BAD_DRIVE",
		9: "ERR_FILE_BAD_PATH",
		10: "ERR_FILE_NO_PERMISSION",
		11: "ERR_FILE_ALREADY_IN_USE",
		12: "ERR_FILE_CANT_OPEN",
		13: "ERR_FILE_CANT_WRITE",
		14: "ERR_FILE_CANT_READ",
		15: "ERR_FILE_UNRECOGNIZED",
		16: "ERR_FILE_CORRUPT",
		17: "ERR_FILE_MISSING_DEPENDENCIES",
		18: "ERR_FILE_EOF",
		19: "ERR_CANT_OPEN",
		20: "ERR_CANT_CREATE",
		43: "ERR_PARSE_ERROR",
		21: "ERROR_QUERY_FAILED",
		22: "ERR_ALREADY_IN_USE",
		23: "ERR_LOCKED",
		24: "ERR_TIMEOUT",
		28: "ERR_CANT_AQUIRE_RESOURCE",
		30: "ERR_INVALID_DATA",
		31: "ERR_INVALID_PARAMETER",
		32: "ERR_ALREADY_EXISTS",
		33: "ERR_DOES_NOT_EXIST",
		34: "ERR_DATABASE_CANT_READ",
		35: "ERR_DATABASE_CANT_WRITE",
		36: "ERR_COMPILATION_FAILED",
		37: "ERR_METHOD_NOT_FOUND",
		38: "ERR_LINK_FAILED",
		39: "ERR_SCRIPT_FAILED",
		40: "ERR_CYCLIC_LINK",
		44: "ERR_BUSY",
		46: "ERR_HELP",
		47: "ERR_BUG",
		49: "ERR_WTF"
	}
```
## Example of Usage

```gdscript
extends Node2D

onready var button = get_node("Button")
onready var Text = get_node("Label")
onready var dir = self.get_script().get_path().replace("usage.gd","")
onready var Loader = preload("scene_loader.gd").instance(self)
var scene_to_load_path = "example_scene.xml"

func _ready():
	print(dir)
	Loader.connect("DONE",self,"on_loaded")
	Loader.connect("PROGRESS",self,"on_progress")
	Loader.connect("ERROR",self,"on_error")
	Loader.slow_down() # this is so the loading process can be seen
	button.connect("pressed",self,"on_button_press")

func on_button_press():
	button.set_disabled(true)
	Loader.load_scene(dir+scene_to_load_path)
	
func on_loaded(scene):
	add_child(scene)
	
func on_progress(percent):
	Text.set_text(str(percent*100)+'%')

func on_error(err):
	pass
```
