extends Node2D

@export var depths_map: DepthsMap

var screen_size: Rect2

func _ready() -> void:
	screen_size = get_viewport_rect()
	print("Screen size: " + str(screen_size))

func draw_submarine() -> void:
	var pos: Vector2 = screen_size.get_center()
	draw_circle(pos, 30, Color.DARK_GREEN)

func _draw() -> void:
	draw_submarine()

func _process(_delta: float) -> void:
	queue_redraw()
