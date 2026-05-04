extends Node3D

@export_group("Movement Settings")
@export var move_speed: float = 20.0
@export var acceleration: float = 10.0
@export var look_sensitivity: float = 0.1

@export_group("Zoom Settings")
@export var zoom_speed: float = 5.0
@export var min_fov: float = 20.0
@export var max_fov: float = 90.0

# We point to the child camera specifically to fix the error in image_c4e000.png
@onready var camera: Camera3D = $Camera3D

var _velocity: Vector3 = Vector3.ZERO
var _target_fov: float = 75.0

func _ready():
	if camera:
		_target_fov = camera.fov

func _process(delta: float):
	handle_movement(delta)
	handle_zoom(delta)

func handle_movement(delta: float):
	# Using the action names from your image_c4e43c.png
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# THE KEY CHANGE: We use the CAMERA'S basis instead of the Node3D's basis.
	# This means 'forward' is wherever the lens is pointing.
	var direction = (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		_velocity = _velocity.lerp(direction * move_speed, acceleration * delta)
	else:
		_velocity = _velocity.lerp(Vector3.ZERO, acceleration * delta)
	
	global_position += _velocity * delta

func _input(event):
	# Rotation logic: Hold Right Click to look around
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		# Rotate the whole "Head" horizontally
		rotate_y(deg_to_rad(-event.relative.x * look_sensitivity))
		# Rotate only the "Camera" vertically (prevents weird tilting)
		camera.rotate_x(deg_to_rad(-event.relative.y * look_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# Scroll logic
	if event.is_action_pressed("scroll_up"):
		_target_fov = clamp(_target_fov - zoom_speed, min_fov, max_fov)
	if event.is_action_pressed("scroll_down"):
		_target_fov = clamp(_target_fov + zoom_speed, min_fov, max_fov)

func handle_zoom(delta: float):
	if camera:
		camera.fov = lerp(camera.fov, _target_fov, delta * 10.0)
