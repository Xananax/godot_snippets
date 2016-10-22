
extends Node2D

onready var logo = get_node("TranslatedNode/Logo")

func _ready():
	set_process(true)
	
func _process(delta):
	logo.set_global_pos(get_viewport().get_mouse_pos())