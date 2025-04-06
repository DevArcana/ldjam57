extends Interactable

# DO NOT MODIFY!
@export var offset_max_abs: float = 0.4
@export var angle: float = 0.5
@export var levels := [-0.4, -0.2, 0.0, 0.2, 0.4]
#@export var levels := [0.4, 0.2, 0.0, -0.2, -0.4]

@export var smooth_offset: float = -0.2
@export var offset: float = -0.2
@export var level: int = 0

var interacting := false

var original_pos: Vector3
var tween: Tween
func _ready() -> void:
	original_pos = transform.origin

func _unhandled_input(event: InputEvent) -> void:
	if not interacting:
		return
	
	if event is InputEventMouseMotion:
		var dist: float = event.relative.x * 0.001 - event.relative.y * 0.001
		smooth_offset += dist
		_set_offset_to_nearest_level()

func _set_offset_to_nearest_level() -> void:
	var dist: float = 1000000.0
	var new_offset: float = 0.0
	
	for level: float in levels:
		var dist_to_level: float = abs(level - smooth_offset)
		if dist_to_level < dist:
			dist = dist_to_level
			new_offset = level
	offset = new_offset
	
	if abs(offset) > offset_max_abs:
		offset = sign(offset) * offset_max_abs
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", original_pos + Vector3(0.0, offset*sin(angle), -offset*cos(angle)), 0.1)
	_set_level()

func _set_level() -> void:
	var i := 0
	while i < levels.size():
		if offset >= levels[i]:
			i += 1
		else:
			break
	level = i - 1

## override this
func interact_start() -> void:
	Events.lock_camera.emit()
	interacting = true

## override this
func interact_stop() -> void:
	_set_offset_to_nearest_level()
	Events.unlock_camera.emit()
	interacting = false
	smooth_offset = offset
