extends Node2D

func _physics_process(delta: float) -> void:
	var distance_to_target: float = INF
	var target: Node2D
	for i in Submarine.targets:
		var dist := i.global_position.distance_to(Submarine.submarine2d.global_position)
		if dist < distance_to_target:
			distance_to_target = dist
			target = i
	
	if target:
		look_at(target.global_position)
		rotate(PI/2.0)
