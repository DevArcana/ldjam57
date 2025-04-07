extends Scannable
class_name Target

func _ready() -> void:
	super._ready()
	Submarine.targets.append(self)

func _on_body_entered(body: Node) -> void:
	if body is Submarine2D:
		Submarine.score += 1
		Submarine.targets.remove_at(Submarine.targets.find(self))
		Events.score_changed.emit()
		queue_free()
