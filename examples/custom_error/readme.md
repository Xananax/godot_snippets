# custom_error
## Example Implementation

```gdscript
####################################################
#  Custom Error Class
# demonstrates class-as-a-file, cloning, type 
# checking
####################################################

var message
var message_raw
var type = "Error"
var code = 0

func _init(_message="",_args=[]):
	set_message(_message,_args)

func set_message(_message,_args):
	message_raw = _message
	if _args.size():
		message = _message % _args
	else:
		message = message_raw
	
func clone(_args=[]):
	var e = get_script().new(message_raw,_args)
	e.type = type
	e.code = code
	return e
	
func as_string():
	return "(%s (%s) message:\"%s\")" % [type,code,message]

func is_error(obj):
	var type = typeof(obj)
	if type == TYPE_OBJECT && obj extends get_script():
		return true
	else:
		return false
```
## Example of Usage

```gdscript
onready var Error = preload("custom_error.gd")
onready var label = get_node("Label")
onready var MasterError = Error.new("The number that produced the error was `%s`")

func _ready():
	set_message("click to maybe get an error")

func set_message(text):
	label.set_text(text)

func function_that_may_return_an_error():
	randomize()
	var num = rand_range(0,1)
	
	if num > .5 :
		return MasterError.clone([num])
	else:
		return num
		
func _on_Button_pressed():

	var result = function_that_may_return_an_error()
		
	if MasterError.is_error(result) :
		set_message("Got an error! %s" % result.as_string())
	else:
		set_message("nope, no error, got this number: %s" % str(result))
```
