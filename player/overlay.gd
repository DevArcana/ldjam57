extends ColorRect

@export var death_screen: ColorRect
@export var win_screen: ColorRect

func _display_death() -> void:
	death_screen.visible = true

func _display_win() -> void:
	win_screen.visible = true

func _reactor_overheat() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.ORANGE, 2.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(_display_death)

func _oxygen_depleted() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color.NAVY_BLUE, 2.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(_display_death)

func _score_changed() -> void:
	if len(Submarine.targets) == 0:
		var tween := get_tree().create_tween()
		tween.tween_property(self, "color", Color.GREEN, 2.0).set_trans(Tween.TRANS_EXPO)
		tween.tween_callback(_display_win)

func _ready() -> void:
	Events.death_reactor_overheat.connect(_reactor_overheat)
	Events.death_oxygen_depleted.connect(_oxygen_depleted)
	Events.score_changed.connect(_score_changed)

func _physics_process(delta: float) -> void:
	if death_screen.visible == false:
		return
	
	if Input.is_action_just_pressed("restart"):
		Submarine.restart_game()
