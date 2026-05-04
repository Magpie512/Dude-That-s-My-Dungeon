extends CanvasLayer

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Escape Key
		toggle_menu()

func toggle_menu():
	visible = !visible
	
	if visible:
		# Show the mouse so they can click 'Invite' or 'Options'
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Control/CenterContainer/VBoxContainer/Invite.grab_focus()
	else:
		# Hide the mouse again so they can play
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_invite_button_pressed():
	print("Opening Steam/Network Overlay...")
	# If using Steam: Steam.activateGameOverlayInviteDialog(lobby_id)

func _on_quit_button_pressed():
	# Crucial: Reset mouse before leaving or the Main Menu will be broken
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://User Interface/Main Menu/MainMenu.tscn")
