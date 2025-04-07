extends Control

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index("Master")
	$VBoxContainer/VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	$VBoxContainer/VolumeSlider.connect("value_changed", _on_h_slider_value_changed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
