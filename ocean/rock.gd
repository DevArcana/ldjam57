extends Scannable
class_name Rock

@export var collider: CollisionPolygon2D
@export var mesh: Polygon2D

func _ready() -> void:
	super._ready()
	var x := 0.0
	var y := 0.0
	var p := randi_range(5, 9)
	var step := (2 * PI) / float(p)
	var points: PackedVector2Array = []
	for i in p:
		var rot := i * step
		points.append(Vector2(30.0 + randf() * 60.0, 0.0).rotated(rot))
	
	collider.polygon = points
	mesh.polygon = points
