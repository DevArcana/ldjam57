extends Node
class_name DepthsMap

@export var submarine_speed: float = 50.0

class DepthObject:
	var position: Vector2
	var shape: PackedVector2Array

@onready var submarine_position: Vector2 = Vector2.ZERO
@onready var objects: Array[DepthObject] = []

func test_object() -> DepthObject:
	var object: DepthObject = DepthObject.new()
	object.position = Vector2(50, 50)
	object.shape = PackedVector2Array(Array([
		Vector2(0.0, 0.0), Vector2(50.0, 10.0), Vector2(40.0, 60.0), Vector2(-10.0, 40.0)
	]))
	return object

func _ready() -> void:
	objects.append(test_object())
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("submarine_forward"):
		submarine_position += Vector2(0.0, submarine_speed * _delta)
	elif Input.is_action_pressed("submarine_backward"):
		submarine_position -= Vector2(0.0, submarine_speed * _delta * 0.5)
