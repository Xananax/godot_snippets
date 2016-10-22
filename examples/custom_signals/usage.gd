extends Node2D

onready var emitter = preload("custom_signals.gd").new()

func _ready():
	emitter.connect("custom_signal",self,"on_custom_signal")
	emitter.connect("custom_signal_with_params",self,"on_custom_signal_with_params")

func on_custom_signal():
	get_node("Control1/Label").set_text("signal 1 received")

func on_custom_signal_with_params(a,b):
	get_node("Control2/Label").set_text("signal 2 received with params: ("+a+","+b+")")

func _on_Button1_pressed():
	emitter.emit_custom_signal()


func _on_Button2_pressed():
	emitter.emit_custom_signal_with_params("a","b")
