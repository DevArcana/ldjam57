extends OmniLight3D

@export var alarm: AudioStreamPlayer3D

func enable_alarm() -> void:
	light_color = Color.RED
	alarm.play()

func disable_alarm() -> void:
	light_color = Color.WHITE
	alarm.stop()
