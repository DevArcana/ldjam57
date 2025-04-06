extends Interactable

# DO NOT MODIFY!
@export var offset_max_abs: float = 0.4
@export var angle: float = 0.5
@export var levels := [-0.4, -0.2, 0.0, 0.2, 0.4]
#@export var levels := [0.4, 0.2, 0.0, -0.2, -0.4]

@export var offset: float = -0.2
@export var level: int = 0

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

func _set_offset_to_nearest_level() -> void:
	var dist: float = 1000000.0
	var new_offset: float = 0.0
	
	for level: float in levels:
		var dist_to_level: float = abs(level - offset)
		if dist_to_level < dist:
			dist = dist_to_level
			new_offset = level
	offset = new_offset

func _set_level() -> void:
	var i := 0
	while i < levels.size():
		if offset >= levels[i]:
			i += 1
		else:
			break
	level = i - 1

func _physics_process(delta: float) -> void:	
	if abs(offset) > offset_max_abs:
		offset = sign(offset) * offset_max_abs
	transform.origin = original_pos + Vector3(0.0, offset*sin(angle), -offset*cos(angle))
	_set_level()

## override this
func interact_start() -> void:
	Events.lock_camera.emit()
	interacting = true

## override this
func interact_stop() -> void:
	_set_offset_to_nearest_level()
	Events.unlock_camera.emit()
	interacting = false
