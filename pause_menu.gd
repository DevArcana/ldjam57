extends Control

var bus_index: int

func _ready() -> void:
	visible = false
	bus_index = AudioServer.get_bus_index("Master")
	$VBoxContainer/VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	$VBoxContainer/VolumeSlider.connect("value_changed", _on_h_slider_value_changed)

func resume() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func pause() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func pauseESC() -> void:
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed() ->void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	Submarine.restart_game()

func _on_exit_pressed() -> void:
	resume()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(delta: float) -> void:
	pauseESC()

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
