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