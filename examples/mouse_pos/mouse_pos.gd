
extends Node2D

var thing

#method 1:
func _process(delta):
	thing.set_global_pos(get_viewport().get_mouse_pos())
	
#method 2:
func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		thing.set_global_pos(event.pos)