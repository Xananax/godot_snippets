signal custom_signal
signal custom_signal_with_params(a,b)


func emit_custom_signal():
	emit_signal("custom_signal")
	
func emit_custom_signal_with_params(a,b):
	emit_signal("custom_signal_with_params",a,b)