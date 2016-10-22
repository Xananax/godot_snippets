extends Node
var scenes_path = "res://examples"
var Loader
var scenes
var current_source_text = ""
onready var tween_in = Tween.new()
onready var tween_out = Tween.new()
onready var animation_node = get_node("Loading/Animation")
onready var progress_node = get_node("Loading/Progress")
onready var root_node = get_tree().get_root()
onready var scenes_node = get_node("Scenes")
onready var loading_node = get_node("Loading")
onready var choice_node = get_node("Choice")
onready var dialog_node = get_node("WindowDialog")
onready var source_label_node = get_node("WindowDialog/ScrollContainer/Label")
onready var scene_buttons_node = get_node("Buttons")
onready var back_btn_node = get_node("Buttons/Back_btn")
onready var source_btn_node = get_node("Buttons/Source_Btn")
onready var LoaderDispenser = preload("res://examples/scene_loader/scene_loader.gd")
onready var Browser = preload("res://examples/directory_reader/directory_reader.gd").new()
onready var _read_scene_dir = funcref(self,"read_scene_dir")
onready var _read_scene_file = funcref(self,"read_scene_file")

func _ready():
	Loader = LoaderDispenser.instance(self)
	Loader.connect("DONE",self,"set_new_scene")
	Loader.connect("PROGRESS",self,"set_progress")
	back_btn_node.connect("pressed",self,"back_to_choice")
	source_btn_node.connect("pressed",self,"show_source")
	choice_node.connect("button_selected",self,"on_scene_select")
	tween_out.connect("tween_complete",self,"on_tween")
	Loader.set_initial_scene(get_last_child(scenes_node))
	add_child(tween_in)
	add_child(tween_out)
	read_all_scenes(scenes_path)
	initial_state()

func get_last_child(node):
	var index = node.get_child_count() -1
	if index >= 0:
		return node.get_child(index)
	return null

func load_scene(idx):
	var game = scenes[idx]
	var path = game.game_scene
	dialog_node.set_title(game.game_name)
	current_source_text = read_file(game.game_example).replace("\t","    ")
	source_label_node.set_text(current_source_text)
	
	Loader.load_scene(path)
	loading_node.show();
	scenes_node.hide();
	progress_node.set_val(0)
	#animation_node.play("loading")
	
func read_file(path):
	var file_buffer = File.new();
	var err = file_buffer.open(path,File.READ)
	if err == OK:
		return file_buffer.get_as_text()
	else:
		print("Error: %s" % err)
		return err
		
func set_progress(progress):
	progress_node.set_val(progress)
	#var len = animation_node.get_current_animation_length()
	# call this on a paused animation. use "true" as the second parameter to force the animation to update
	#animation_node.seek(progress * len, true)

func set_new_scene(scene):
	scenes_node.add_child(scene)
	slide(scene,"in")
	scene_buttons_node.show();
	scenes_node.show();
	choice_node.hide();
	loading_node.hide();

func on_tween(obj,key):
	initial_state()

func slide(scene,direction="in"):
	if !scene:
		return
	var rect = scene.get_viewport_rect()
	var x = - rect.size.x
	var initial_pos = Vector2(x,0)
	if direction == "in":
		scene.set_pos(initial_pos)
		tween_in.interpolate_property(scene, "transform/pos", initial_pos, Vector2(0,0), .5, Tween.TRANS_BACK, Tween.EASE_OUT)
		tween_in.start()
	else:
		tween_out.interpolate_property(scene, "transform/pos",scene.get_pos(),initial_pos, .3, Tween.TRANS_BACK, Tween.EASE_IN)
		tween_out.start()
		
func back_to_choice():
	slide(Loader.get_scene(),"out")

func initial_state():
	current_source_text = ""
	Loader.free_current_scene();
	scenes_node.hide();
	loading_node.hide();
	choice_node.show();
	scene_buttons_node.hide();
	
func read_all_scenes(path):
	scenes = Browser.read_dir(path,_read_scene_dir,null)
	for scene_data in scenes:
		var name = scene_data.game_name
		var path = scene_data.game_scene
		var author = scene_data.game_author
		choice_node.add_button(name)

func read_scene_dir(data,STOP):
	var files = Browser.read_dir(data.path,null,_read_scene_file);
	var scene = null
	if(data.name == "_template"):
		return null
	if files.size():
		scene = files[0]
	return scene
	
func read_scene_file(data,STOP):
	if data.name == 'engine.cfg':
		var config = ConfigFile.new()
		var err = config.load(data.path)
		if err == OK:
			data.game_name = config.get_value("application","name")
			data.game_scene = data.dirname+'/'+config.get_value("application","main_scene").replace("res://","")
			data.game_example = data.dirname+"/"+data.dirname.get_file()+".gd"
			if config.has_section_key("application","author"):
				data.game_author = config.get_value("application","author")
			else:
				data.game_author = "unknown author"
			return data

func show_source():
	dialog_node.popup()
	
func on_scene_select(idx):
	load_scene(idx)

func _on_Button_pressed():
	if current_source_text != "":
		OS.set_clipboard(current_source_text)
