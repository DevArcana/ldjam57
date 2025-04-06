extends Interactable

# DO NOT MODIFY!
@export var offset_max_abs: float = 0.4
@export var angle: float = 0.5

@export var offset: float = 0.0

var interacting := false

var original_pos: Vector3
func _ready() -> void:
	original_pos = transform.origin

func _unhandled_input(event: InputEvent) -> void:
	if not interacting:
		return
	
	if event is InputEventMouseMotion:
		var dist: float = event.relative.x * 0.01
		offset += dist

func _physics_process(delta: float) -> void:	
	if abs(offset) > offset_max_abs:
		offset = sign(offset) * offset_max_abs
	transform.origin = original_pos + Vector3(0.0, offset*sin(angle), -offset*cos(angle))

## override this
func interact_start() -> void:
	Events.lock_camera.emit()
	interacting = true

## override this
func interact_stop() -> void:
	Events.unlock_camera.emit()
	interacting = false
