extends CharacterBody3D

@export_category("References")

## Used for Y-axis rotation.
@export var body: Node3D

## Used for X-axis view rotation.
@export var head: Node3D

@export_category("Settings")
@export_subgroup("View")
@export var mouse_sensitivity: float = 3.68

@export_subgroup("Movement")
@export var movement_speed: float = 2.14

var last_mouse_motion := Vector2.ZERO
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		event = event as InputEventMouseMotion
		var motion: Vector2 = event.screen_relative
		var x: float = (last_mouse_motion.x + motion.x) / 2
		var y: float = (last_mouse_motion.y + motion.y) / 2
		last_mouse_motion = motion
		
		body.rotate_y(-x * deg_to_rad(0.022) * mouse_sensitivity)
		head.rotate_x(-y * deg_to_rad(0.022) * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var wish_dir := body.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	wish_dir = wish_dir.normalized()
	
	velocity = velocity.lerp(wish_dir * movement_speed, 20 * delta)
	
	move_and_slide()
