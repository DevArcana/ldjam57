@tool
extends MeshInstance3D

# DO NOT MODIFY!
@export var offset_max_abs: float = 0.4
@export var angle: float = 0.5

@export var offset: float = 0.0

func _process(delta: float) -> void:
	if abs(offset) > offset_max_abs:
		offset = sign(offset) * offset_max_abs
	transform.origin = Vector3(0.0, offset*sin(angle), -offset*cos(angle))
