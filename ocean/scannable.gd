extends Node2D
class_name Scannable

func _ready() -> void:
	modulate.a = 0.0

var tween: Tween
func reveal() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_interval(1.0)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0)
