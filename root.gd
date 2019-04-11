extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s = preload("res://Label_n.tscn")
var sprites_characters = preload("res://shits.tscn")

#const SIGNAL_PLAYER_HURT = 'playerhurt'

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	for i in range(0, 7):
		var label_number = s.instance()
		$PanelContainer/HBoxContainer.add_child(label_number)
		$PanelContainer/HBoxContainer.get_children()[i].set_text(str(i+1))
		$PanelContainer/HBoxContainer.get_children()[i].connect("pressed_button", self, "_on_button_pressed")
	
	refresh_items(1)
	
	#print(list_files_in_directory('1'))
	
func refresh_items(layer):
	for child in $PanelContainer4/ScrollContainer/VBoxContainer.get_children():
		child.free()
	var dirfiles = list_files_in_directory('res://Sprites/Male/Layer%s' % str(int(layer)-1))
	
	for i in range(0, len(dirfiles)):
		var label_character = sprites_characters.instance()
		$PanelContainer4/ScrollContainer/VBoxContainer.add_child(label_character)
		$PanelContainer4/ScrollContainer/VBoxContainer.get_children()[i].get_children()[1].set_text(dirfiles[i].replace('.png',''))
		$PanelContainer4/ScrollContainer/VBoxContainer.get_children()[i].get_children()[0].texture = load('res://Sprites/Male/Layer%s/%s' % [str(int(layer)-1), str(dirfiles[i])])
		$PanelContainer4/ScrollContainer/VBoxContainer.get_children()[i].connect("pressed_sprite", self, "_on_button_sprite_pressed")
	var label_dots = sprites_characters.instance()
	$PanelContainer4/ScrollContainer/VBoxContainer.add_child(label_dots)
	$PanelContainer4/ScrollContainer/VBoxContainer.get_children()[-1].get_children()[1].set_text('Delete layer')
	$PanelContainer4/ScrollContainer/VBoxContainer.get_children()[-1].connect("pressed_sprite", self, "_on_button_sprite_pressed")
	
func _on_button_pressed(number):
	glob.layer = number
	refresh_items(glob.layer)

func _on_button_sprite_pressed(itemname):
	var nodename = 'PanelContainer4/ScrollContainer/VBoxContainer/%s' % itemname
	var mybutton = get_node('%s' % nodename).get_children()[1]
	var filename = mybutton.get_text()
	var mylayer
	if glob.layer == 0:
		mylayer = str(glob.layer)
	else:
		mylayer = str(glob.layer - 1)
	for sprite in $PanelContainer3.get_children():
		sprite.texture = load('res://Sprites/Male/Layer%s/%s.png' % [mylayer, str(filename)])
	var spritepath = 'PanelContainer2/VBoxContainer/CenterContainer/Sprite%s' % mylayer
	get_node(spritepath).texture = load('res://Sprites/Male/Layer%s/%s.png' % [mylayer, str(filename)])
	glob.alllayers[mylayer] = 'Sprites/Male/Layer%s/%s.png' % [mylayer, str(filename)]

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if not file_name.begins_with(".") and file_name.ends_with('.png'):
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	return files

func _on_Button_pressed():
	var output = []
	var imagecommand = []
	for item in glob.alllayers:
		if glob.alllayers[item] != '':
			imagecommand += ['-page', 0, glob.alllayers[item]]
	imagecommand += ['-set', 'page', '', '-background', 'none', '-layers', 'merge', '-bordercolor', 'none', 'output/result.png' ]
	OS.execute('convert', imagecommand, true, output)
	print(glob.alllayers)
	#convert -page 0 {Male_Hair_25_B,Male_Skin_01,Male_Eyes_01}.png -set page '' -background none -layers merge -bordercolor none result.png 
