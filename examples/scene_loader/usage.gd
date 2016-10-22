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