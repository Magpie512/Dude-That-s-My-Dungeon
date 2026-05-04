extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.002

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Reference to the 'Head' node to rotate it up/down
@onready var head = $Head

func _ready():
	# Captures the mouse so it doesn't leave the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Check if the mouse is moving
	if event is InputEventMouseMotion:
		# Rotate the whole player body left/right (Yaw)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotate only the head up/down (Pitch)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Clamp the vertical rotation so you can't flip upside down
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	
	# Handle Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get movement direction using your Input Map from image_d19afb.png
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# transform.basis ensures movement is relative to where you are looking
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
