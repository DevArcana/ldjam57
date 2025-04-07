extends Area2D

@export var collider: CollisionPolygon2D
@export var polygon: Polygon2D
@export var heat: int = 4

func _ready() -> void:
	polygon.polygon = collider.polygon


func _on_body_entered(body: Node2D) -> void:
	if body is Submarine2D:
		Submarine.external_heat_mod += heat


func _on_body_exited(body: Node2D) -> void:
	if body is Submarine2D:
		Submarine.external_heat_mod -= heat
