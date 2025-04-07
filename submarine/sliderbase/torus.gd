extends Interactable

var interacting := false
var prev_mode: Input.MouseMode
var prev_dir: Vector3 = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if not interacting:
		return
	
	if event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		# Define the interaction plane of the torus
		var up := global_transform.basis * Vector3.UP
		var interaction_plane := Plane(up, global_position)
		
		# construct the ray's origin and normal
		var camera := get_viewport().get_camera_3d()
		var mouse_pos := get_viewport().get_mouse_position()
		var mouse_origin := camera.project_ray_origin(mouse_pos)
		var mouse_normal := camera.project_ray_normal(mouse_pos)
		
		# find intersection of the interaction plane with mouse ray
		var point_variant: Variant = interaction_plane.intersects_ray(mouse_origin, mouse_normal)
		if point_variant == null or not point_variant is Vector3:
			return
		
		var point := point_variant as Vector3
		if point == null:
			return
					
		#DebugDraw3D.draw_sphere(point, 0.01, Color.BLUE)
		#DebugDraw3D.draw_sphere(global_position, 0.01, Color.MAGENTA)
		
		# construct vector from torus to point
		var dir := point - global_position
		if prev_dir == Vector3.ZERO:
			prev_dir = dir
			return
		
		var angle := prev_dir.signed_angle_to(dir, up)
		
		# this is to avoid jitter at low distance
		angle /= max(1.0 / dir.length(), 1.0)
		
		#DebugDraw3D.draw_line(global_position, global_position + dir, Color.GREEN)
		#DebugDraw3D.draw_line(global_position, global_position + prev_dir, Color.RED)
		prev_dir = dir
		rotate_y(angle)
		Submarine.submarine2d.turn -= angle * 5.0

## override this
func interact_start() -> void:
	Events.lock_camera.emit()
	interacting = true
	prev_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	prev_dir = Vector3.ZERO

## override this
func interact_stop() -> void:
	Events.unlock_camera.emit()
	interacting = false
	Input.mouse_mode = prev_mode
