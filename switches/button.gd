extends Interactable

@export var button: Node3D
@export var audio: AudioStreamPlayer3D

signal pressed

const OFFSET: float = -0.015

func interact_start() -> void:
	audio.play()
	pressed.emit()
	button.position.y = OFFSET

func interact_stop() -> void:
	button.position.y = 0
