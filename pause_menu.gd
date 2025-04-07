extends Control

func _ready() -> void:
	visible = false

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

func _on_restart_pressed() ->void:
	resume()
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	resume()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _process(delta: float) -> void:
	pauseESC()
