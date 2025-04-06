extends Node2D

@export var depths_map: DepthsMap

var screen_size: Rect2

func _ready() -> void:
	screen_size = get_viewport_rect()
	print("Screen size: " + str(screen_size))

func draw_submarine() -> void:
	draw_circle(screen_size.get_center(), 30, Color.DARK_GREEN)

func draw_objects() -> void:
	var center: Vector2 = screen_size.get_center()
	for obj in depths_map.objects:
		var transform: Transform2D = Transform2D(0.0, -(center + obj.position - depths_map.submarine_position))
		var polygon: PackedVector2Array = obj.shape * transform
		draw_colored_polygon(polygon, Color.LIGHT_GREEN)

func _draw() -> void:
	draw_objects()
	draw_submarine()

func _process(_delta: float) -> void:
	queue_redraw()
