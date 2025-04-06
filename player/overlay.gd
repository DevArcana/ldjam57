extends ColorRect

@export var death_screen: ColorRect

func _display_death() -> void:
	death_screen.visible = true

func _reactor_overheat() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.ORANGE, 2.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(_display_death)

func _oxygen_depleted() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.NAVY_BLUE, 2.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(_display_death)

func _ready() -> void:
	Events.death_reactor_overheat.connect(_reactor_overheat)
	Events.death_oxygen_depleted.connect(_oxygen_depleted)

func _physics_process(delta: float) -> void:
	if death_screen.visible == false:
		return
	
	if Input.is_action_just_pressed("restart"):
		Submarine.restart_game()
