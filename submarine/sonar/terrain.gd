extends Node2D

@onready var min_size: float = 10
@onready var max_size: float = 500

@onready var size: float = 100
@onready var detla: float = 50
@onready var dir: float = 1

func _draw() -> void:
	draw_circle(Vector2(0.5, 0.5), size, Color.RED)

func _process(_delta: float) -> void:
	size = size + detla * _delta * dir
	if (size > max_size):
		size = max_size
		dir *= -1
	elif (size < min_size):
		size = min_size
		dir *= -1
	print("Test size: " + str(size))
	queue_redraw()
