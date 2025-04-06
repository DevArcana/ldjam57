extends Node

@export var label: Label

func _on_depth_changed() -> void:
	label.text = "Depth [m]\n%.2f" % abs(Submarine.submarine2d.global_position.y)

func _ready() -> void:
	Events.depth_changed.connect(_on_depth_changed)
