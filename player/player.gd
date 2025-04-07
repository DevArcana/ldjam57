extends CharacterBody3D

@export_category("References")

## Used for Y-axis rotation.
@export var body: Node3D

## Used for X-axis view rotation.
@export var head: Node3D

## Used for triggering interactables
@export var interactor: ShapeCast3D

## Used for interaction in mouse mode
@export var camera: Camera3D

## Used for footsteps.
@export var footsteps: AudioStreamPlayer3D

@export_category("Settings")
@export_subgroup("View")
@export var mouse_sensitivity: float = 3.68

@export_subgroup("Movement")
@export var movement_speed: float = 2.14

var locked := false
func _lock_camera() -> void:
	locked = true

func _unlock_camera() -> void:
	locked = false

var last_mouse_motion := Vector2.ZERO
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not locked:
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
	Events.lock_camera.connect(_lock_camera)
	Events.unlock_camera.connect(_unlock_camera)
	Events.hit_rock.connect(_hit_rock)

func _hit_rock() -> void:
	pass

var timer: float = 0.0
var moved: bool = false
func handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var wish_dir := body.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	wish_dir = wish_dir.normalized()
	
	velocity = velocity.lerp(wish_dir * movement_speed, 20 * delta)
	
	move_and_slide()
	
	var vel := velocity.length()
	if vel < 0.01:
		timer = 0.0
		moved = false
		return
	elif not moved:
		moved = true
		footsteps.stop()
		footsteps.play()
		
	timer += vel * delta
	
	var step := 0.8
	if timer > step:
		timer -= step
		footsteps.stop()
		footsteps.play()

var focused: Interactable
var interacting := false
func handle_interactable(interactable: Interactable) -> void:
	if not interacting:
		if interactable == null:
			if focused != null:
				focused.unfocus()
				focused = null
			return
		
		if focused != interactable:
			if focused != null:
				focused.unfocus()
			focused = interactable
			focused.focus()
	
		if focused and Input.is_action_just_pressed("interact"):
			focused.interact_start()
			interacting = true
	else:
		var max_dist: float = abs(interactor.target_position.z)
		max_dist *= max_dist
		if focused and (Input.is_action_just_released("interact") or focused.global_position.distance_squared_to(global_position) > max_dist):
			focused.interact_stop()
			interacting = false

func handle_interactions() -> void:
	var interactable: Interactable = null
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if interactor.is_colliding():
			interactable = interactor.get_collider(0) as Interactable
			assert(interactable != null)
	else:
		var space_state := camera.get_world_3d().get_direct_space_state()
		var mouse_pos := get_viewport().get_mouse_position()
		var params := PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(mouse_pos)
		params.to = params.from + camera.project_ray_normal(mouse_pos) * abs(interactor.target_position.z)
		params.collision_mask = 0b10
		var result := space_state.intersect_ray(params)
		if not result.is_empty():
			interactable = result["collider"] as Interactable
	
	handle_interactable(interactable)

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_interactions()
