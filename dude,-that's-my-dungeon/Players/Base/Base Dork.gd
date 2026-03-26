extends CharacterBody3D

@export_group("Movement")
@export var speed : float = 5.0
@export var acceleration : float = 10.0
@export var friction : float = 12.0

@export_group("Looking")
@export var mouse_sensitivity : float = 0.002

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interact_ray = $Head/Camera3D/RayCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Mouse Look
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	# Interaction Key (E)
	if event.is_action_pressed("ui_accept") or Input.is_key_pressed(KEY_E):
		check_interaction()

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	move_and_slide()

func check_interaction():
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		print("Dork is looking at: ", collider.name)
		# This is where we will eventually trigger doors or pick up items
