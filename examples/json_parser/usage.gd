extends Node2D

onready var JSON = preload("json_parser.gd").new()
onready var dir = self.get_script().get_path().replace("usage.gd","")
onready var button = get_node("Button")
onready var label = get_node("Label")

func _ready():
	button.connect("pressed",self,"on_button_press")

func on_button_press():
	var data = JSON.parse_json(dir+"example.json")
	label.set_text(str(data))