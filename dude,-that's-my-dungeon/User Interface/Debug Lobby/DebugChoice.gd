extends Control

func _on_play_pressed():
	GameState.selected_role = GameState.Role.PLAYER
	get_tree().change_scene_to_file("res://Environment/Playmat.tscn")

func _on_gm_pressed():
	GameState.selected_role = GameState.Role.DM
	get_tree().change_scene_to_file("res://Environment/Playmat.tscn")
