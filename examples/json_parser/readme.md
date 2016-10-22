# json_parser
## Example Implementation

```gdscript
# parses JSON and returns results as an object
# arguments:
#	string path the path to the file
#
# returns:
#	object data a data object

func parse_json(path):
	var file_buffer = File.new();
	var err = file_buffer.open(path,File.READ)
	if err == OK:
		var json_str = file_buffer.get_as_text()
		return parse_json_text(json_str)
	else:
		print("Error: %s" % [get_file_error(err)])
		return {}
		
func parse_json_text(json_str):
	if json_str == "":
		return {"error":"empty string"}
	var data = {}
	var err = data.parse_json(json_str)
	if err == OK:
		return data
	else:
		print("Error: %s" % [get_json_error(err)])
		return {}
		
func get_file_error(err):
	if err < file_errors.size():
		return file_errors[err]
	return "unknown error: "+str(err)

func get_json_error(err):
	if err == ERR_PARSE_ERROR:
		return "ERR_PARSE_ERROR"
	return "unknown error: "+str(err)

var file_errors = [
	"OK",
	"FAILED",
	"ERR_UNAVAILABLE",
	"ERR_UNCONFIGURED",
	"ERR_UNAUTHORIZED",
	"ERR_PARAMETER_RANGE_ERROR",
	"ERR_OUT_OF_MEMORY",
	"ERR_FILE_NOT_FOUND",
	"ERR_FILE_BAD_DRIVE",
	"ERR_FILE_BAD_PATH",
	"ERR_FILE_NO_PERMISSION",
	"ERR_FILE_ALREADY_IN_USE",
	"ERR_FILE_CANT_OPEN",
	"ERR_FILE_CANT_WRITE",
	"ERR_FILE_CANT_READ",
	"ERR_FILE_UNRECOGNIZED",
	"ERR_FILE_CORRUPT",
	"ERR_FILE_MISSING_DEPENDENCIES",
	"ERR_FILE_EOF"
]
```
## Example of Usage

```gdscript
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
```
