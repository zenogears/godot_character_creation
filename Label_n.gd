extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var layer = ''
signal pressed_button
#var root = preload("res://root.gd")

func _on_Label_n_pressed():
	if '@' in $".".get_name():
		layer = int($".".get_name().split('@')[2])
	else:
		layer = 1
	emit_signal('pressed_button', layer)