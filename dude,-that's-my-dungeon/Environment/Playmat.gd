# res://Environment/Level.gd
extends Node3D

@onready var player = $PlayerBase
@onready var dm = $DMHead # your DM Head node

func _ready():
	match GameState.selected_role:
		GameState.Role.PLAYER:
			player.show()
			player.set_physics_process(true)
			dm.hide()
			dm.set_process(false)
			dm.set_physics_process(false)
		GameState.Role.DM:
			dm.show()
			dm.set_process(true)
			player.hide()
			player.set_physics_process(false)
			# Also disable the player's camera so DM camera becomes active
			player.get_node("Head/Camera3D").current = false
			dm.get_node("Camera3D").current = true
