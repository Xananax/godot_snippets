
extends Node

onready var Buttons = get_node("Control/ScrollContainer/VBoxContainer/Files")
onready var DirectoryReader = preload("directory_reader.gd").new()
onready var _on_dir = funcref(self,"on_dir")
onready var _on_file = funcref(self,"on_file")

var dirs = []
var files = []
var all_files = []
var previous = []

func _ready():
	get_node("Control").set_size(get_viewport().get_rect().size)
	Buttons.connect("button_selected",self,"on_selected")
	read_files("/")

func sort_names(a,b):
	return a.name < b.name
	
func read_files(path):
	previous.append(path)
	dirs = []
	files = []
	all_files = []
	Buttons.clear()
	DirectoryReader.read_dir(path,_on_dir,_on_file)
	Buttons.add_button('/..')
	dirs.sort_custom(self,"sort_names")
	files.sort_custom(self,"sort_names")
	for dir in dirs:
		Buttons.add_button("/"+dir.name)
		all_files.append(dir)
	for file in files:
		Buttons.add_button(file.basename+"  -- "+str(file.size))
		all_files.append(file)
	
func on_dir(dir,STOP):
	if dir.name[0] != ".":
		dirs.append(dir)
	
func on_file(file,STOP):
	if file.name[0] != ".":
		files.append(file)

func back():
	previous.pop_back()
	var size = previous.size()
	if size >= 1:
		var current = previous[size-1]
		previous.pop_back()
		read_files(current)
	else:
		read_files("/")

func on_selected(idx):
	if idx == 0:
		back()
		return
	var selected = all_files[idx-1]
	var path = selected.path
	var type = selected.type
	if type == DirectoryReader.TYPE_DIRECTORY:
		read_files(path)