extends Interactable

@export var start_on: bool = false
@export var flick: Node3D
@export var audio: AudioStreamPlayer3D

signal toggled_on
signal toggled_off

var toggle_state := false
var elapsed := 0.0

func toggle() -> void:
	toggle_state = not toggle_state
	flick.rotation.x = -flick.rotation.x
	audio.play()
	
	if toggle_state:
		toggled_on.emit()
	else:
		toggled_off.emit()

func interact_start() -> void:
	toggle()
	elapsed = Time.get_ticks_msec()

func interact_stop() -> void:
	var dt := Time.get_ticks_msec() - elapsed
	if dt > 250:
		toggle()

func _ready() -> void:
	if start_on:
		await get_tree().process_frame
		toggle()
