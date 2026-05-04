extends Node3D

@export_group("Movement Settings")
@export var move_speed: float = 20.0
@export var acceleration: float = 10.0
@export var look_sensitivity: float = 0.1

@export_group("Zoom Settings")
@export var zoom_speed: float = 5.0
@export var min_fov: float = 20.0
@export var max_fov: float = 90.0

@onready var camera: Camera3D = $Camera3D
@onready var player_menu = $PlayerMenu  # ← add this

var _velocity: Vector3 = Vector3.ZERO
var _target_fov: float = 75.0
var _yaw: float = 0.0
var _pitch: float = 0.0

func _ready():
	if camera:
		_target_fov = camera.fov

func _process(delta: float):
	if player_menu.visible:  # ← guard
		return
	handle_movement(delta)
	handle_zoom(delta)

func handle_movement(delta: float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_vec = Vector3(input_dir.x, 0, input_dir.y)
	if Input.is_action_pressed("jump"):
		move_vec.y += 1.0
	if Input.is_action_pressed("crouch"):
		move_vec.y -= 1.0
	var direction = (camera.global_transform.basis * move_vec).normalized()
	if direction:
		_velocity = _velocity.lerp(direction * move_speed, acceleration * delta)
	else:
		_velocity = _velocity.lerp(Vector3.ZERO, acceleration * delta)
	global_position += _velocity * delta

func _input(event):
	if player_menu.visible:  # ← guard
		return
	if event is InputEventMouseMotion:
		_yaw -= event.relative.x * look_sensitivity
		_pitch -= event.relative.y * look_sensitivity
		_pitch = clamp(_pitch, -89.9, 89.9)
		rotation_degrees.y = _yaw
		camera.rotation_degrees.x = _pitch
	if event.is_action_pressed("scroll_up"):
		_target_fov = clamp(_target_fov - zoom_speed, min_fov, max_fov)
	if event.is_action_pressed("scroll_down"):
		_target_fov = clamp(_target_fov + zoom_speed, min_fov, max_fov)

func handle_zoom(delta: float):
	if camera:
		camera.fov = lerp(camera.fov, _target_fov, delta * 10.0)
