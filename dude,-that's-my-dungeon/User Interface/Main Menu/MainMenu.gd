extends Control

# Use '..' to go up to CanvasLayer, then find 'debug'
@onready var debug_button = $debug

func _ready():
	if debug_button:
		debug_button.pressed.connect(_on_debug_pressed)
	else:
		print("Error: Could not find debug area button!")

func _on_debug_pressed():
	get_tree().change_scene_to_file("res://User Interface/Debug Lobby/DebugChoice.tscn")

func _on_quit_pressed():
	get_tree().quit()
