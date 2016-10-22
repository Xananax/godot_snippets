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