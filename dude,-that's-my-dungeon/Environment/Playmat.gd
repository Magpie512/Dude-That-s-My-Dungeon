extends Node3D

@onready var player = $PlayerBase
@onready var dm = $DMHead

func _ready():
	match GameState.selected_role:
		GameState.Role.PLAYER:
			player.set_physics_process(true)
			player.set_process(true)
			player.set_process_unhandled_input(true)
			player.set_process_input(true)
			player.get_node("Head/Camera3D").current = true
			dm.set_process(false)
			dm.set_process_unhandled_input(false)
			dm.set_process_input(false)
			dm.get_node("Camera3D").current = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		GameState.Role.DM:
			dm.set_process(true)
			dm.set_process_unhandled_input(true)
			dm.set_process_input(true)          # ← this is what enables _input()
			dm.global_position = Vector3(0, 10, 0)
			dm.get_node("Camera3D").current = true
			dm.get_node("Camera3D").rotation_degrees.x = -45.0
			player.set_physics_process(false)
			player.set_process(false)
			player.set_process_unhandled_input(false)
			player.set_process_input(false)     # ← disable player's _input too
			player.get_node("Head/Camera3D").current = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # was MOUSE_MODE_VISIBLE
