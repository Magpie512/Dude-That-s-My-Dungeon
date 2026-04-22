extends CharacterBody3D

@export_group("Movement")
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var acceleration: float = 10.0
@export var friction: float = 12.0
@export var rotation_speed: float = 12.0

@export_group("Physics")
@export var jump_velocity: float = 4.5
@export var gravity_multiplier: float = 1.0

@onready var visuals = $Visuals # The node containing your mesh

func _physics_process(delta: float) -> void:
	# 1. Handle Gravity
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Get Input Direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Align movement with the camera orientation
	var camera = get_viewport().get_camera_3d()
	var direction = Vector3.ZERO
	
	if camera:
		var forward = camera.global_basis.z
		var right = camera.global_basis.x
		forward.y = 0 # Keep movement horizontal
		right.y = 0
		direction = (forward * input_dir.y + right * input_dir.x).normalized()

	# 4. Movement Logic (Acceleration & Friction)
	var target_speed = run_speed if Input.is_action_pressed("shift") else walk_speed
	var target_velocity = direction * target_speed

	if direction.length() > 0:
		# Accelerate
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)
		
		# Smooth Rotation: Turn the visuals to face movement direction
		var target_rotation = atan2(-direction.x, -direction.z)
		visuals.rotation.y = lerp_angle(visuals.rotation.y, target_rotation, rotation_speed * delta)
	else:
		# Apply Friction to stop
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	move_and_slide()
	
	# 5. Animation Hook (Basic Example)
	# update_animations(direction.length())

func update_animations(moving: float):
	# If using an AnimationTree, set your blend positions here
	# $AnimationTree.set("parameters/movement/blend_position", moving)
	pass
