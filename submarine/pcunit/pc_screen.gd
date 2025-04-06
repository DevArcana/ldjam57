extends Node

@export var label: Label

func _physics_process(delta: float) -> void:
	var distance_to_target: float = INF
	for i in Submarine.targets:
		var dist := i.global_position.distance_to(Submarine.submarine2d.global_position)
		if dist < distance_to_target:
			distance_to_target = dist
	
	label.text = "Distance [m]\n%.2f\nTargets Left\n%s" % [distance_to_target, len(Submarine.targets)]
