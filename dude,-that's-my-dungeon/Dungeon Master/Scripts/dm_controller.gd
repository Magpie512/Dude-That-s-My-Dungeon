extends Node3D

@export_group("Movement Settings")
@export var mouse_sensitivity : float = 0.1
# Note: WASD speed is tied to mouse_sensitivity * 100 as requested

@export_group("Zoom Settings")
@export var zoom_speed : float = 1.0
@export var min_zoom : float = 2.0
@export var max_zoom : float = 40.0

@onready var camera = $Camera3D

var is_panning : bool = false

func _process(delta):
	var input_dir = Vector2.ZERO
	
	# Keyboard Movement (WASD + Arrow Keys)
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_dir.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_dir.y += 1
		
	if input_dir != Vector2.ZERO:
		var move_vec = Vector3(input_dir.x, 0, input_dir.y).normalized()
		# translate_object_local ensures 'Forward' is relative to camera rotation
		translate_object_local(move_vec * mouse_sensitivity * 100.0 * delta)

func _input(event):
	# Mouse Panning (Right Click to Drag)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_panning = event.pressed
			if is_panning:
				Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		# Zoom Logic (Mouse Wheel)
		# Wheel Up = Get Closer (Lower the Controller Y)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_controller(-zoom_speed)
		# Wheel Down = Get Further (Raise the Controller Y)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_controller(zoom_speed)
			
	if event is InputEventMouseMotion and is_panning:
		# Panning moves the whole controller
		var drag_vec = Vector3(-event.relative.x, 0, -event.relative.y)
		global_translate(drag_vec * mouse_sensitivity)

func zoom_controller(amount):
	# By moving global_position.y, we force vertical movement 
	# This stops the camera from sliding on the X/Z axis when zooming
	global_position.y = clamp(global_position.y + amount, min_zoom, max_zoom)
