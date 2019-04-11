extends Control

var spriten = ''
signal pressed_sprite
#var root = preload("res://root.gd")

func _on_Button_pressed():
	emit_signal('pressed_sprite', $".".get_name())
