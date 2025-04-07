extends Interactable

var interacting := false
var last_mouse_motion: Vector2 = Vector2.ZERO
var torus_rotation: float = 0.0

const skip_frames := 10
var skipped := 0

func vector_direction(from: Vector2, to: Vector2) -> int:
	var cross: float = from.x * to.y - from.y * to.x
	if is_zero_approx(cross):
		return 0
	elif cross > 0.0:
		return 1
	else:
		return -1

func _unhandled_input(event: InputEvent) -> void:
	if not interacting:
		return
	
	if event is InputEventMouseMotion:
		
		if skipped == 0:
			last_mouse_motion = event.position
			skipped += 1
			return
		if skipped < skip_frames:
			skipped += 1
			return
		
		var pos: Vector2 = event.position
		#var diff: Vector2 = event.relative
		#var prev := pos - diff
		
		#var angle := prev.angle_to(pos)
		#var angle := pos.angle_to(diff)
		var angle := last_mouse_motion.angle_to(pos)
		
		var cross := vector_direction(last_mouse_motion, pos)
		
		print("\nPosition: " + str(pos))
		#print("Diff: " + str(diff))
		print("Previous: " + str(last_mouse_motion))
		print("Angle: " + str(angle))
		print("Angle: " + str(rad_to_deg(angle)))
		print("Direction: " + str(cross))
		print("\n\n")
		
		skipped = 0
		
		#transform.origin
		torus_rotation += cross * event.relative.length()
		rotation.y = torus_rotation
		
		#if last_mouse_motion == Vector3.ZERO:
			#last_mouse_motion = event.position
			#return
		
		#var dot := event.position.dot(event.relative)
		#
		#var vec_to_last := last_mouse_motion - transform.origin
		#var vec_to_curr := event.position - transform.origin
		#
		#get_viewport()
		#var dist: float = event.relative.x * 0.001 - event.relative.y * 0.001

## override this
func interact_start() -> void:
	Events.lock_camera.emit()
	interacting = true

## override this
func interact_stop() -> void:
	Events.unlock_camera.emit()
	interacting = false
