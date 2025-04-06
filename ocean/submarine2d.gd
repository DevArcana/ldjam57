extends RigidBody2D
class_name Submarine2D

var vertical: int = 0
var horizontal: int = 0

func _ready() -> void:
	Submarine.submarine2d = self

func _physics_process(_delta: float) -> void:
	apply_force(Vector2(horizontal, vertical).rotated(rotation))
	Events.depth_changed.emit()
