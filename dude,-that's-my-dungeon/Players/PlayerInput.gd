extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var player_menu = $PlayerMenu

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.002

@export_group("Camera Zoom")
@export var zoom_speed: float = 1.0
@export var min_distance: float = 0.0   # 0 = first-person
@export var max_distance: float = 10.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Camera starts at its scene-defined position (first-person by default).
# _camera_distance = 0 means the camera sits right at the Head origin.
var _camera_distance: float = 0.0
var _target_distance: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Snap to whatever offset is set in the scene so designers can tweak it.
	_camera_distance = -camera.position.z
	_target_distance = _camera_distance

func _unhandled_input(event):
	if player_menu.visible:
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	# Scroll to pull camera in/out
	if event.is_action_pressed("scroll_up"):
		_target_distance = clamp(_target_distance - zoom_speed, min_distance, max_distance)
	if event.is_action_pressed("scroll_down"):
		_target_distance = clamp(_target_distance + zoom_speed, min_distance, max_distance)

func _process(delta: float):
	# Smoothly interpolate the camera back along its local -Z axis
	_camera_distance = lerp(_camera_distance, _target_distance, delta * 12.0)
	camera.position.z = _camera_distance

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not player_menu.visible:
		velocity.y = JUMP_VELOCITY

	if not player_menu.visible:
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
