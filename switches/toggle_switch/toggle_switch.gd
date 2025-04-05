extends StaticBody3D

@export var meshes: Array[MeshInstance3D]
@export var flick: Node3D
@export var audio: AudioStreamPlayer3D

signal toggled_on
signal toggled_off

const highlight_material: Material = preload("res://assets/materials/interactive_outline.tres")

var focused := false
var toggle_state := false

func focus() -> void:
	if focused:
		return
	
	focused = true
	
	for mesh in meshes:
		mesh.material_overlay = highlight_material

func unfocus() -> void:
	if not focused:
		return
	
	focused = false
	
	for mesh in meshes:
		mesh.material_overlay = null

func _mouse_enter() -> void:
	focus()

func _mouse_exit() -> void:
	unfocus()

func _physics_process(delta: float) -> void:
	if focused:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			unfocus()
			return
		
		if Input.is_action_just_pressed("left_click"):
			toggle_state = not toggle_state
			flick.rotation.x = -flick.rotation.x
			audio.play()
			
			if toggle_state:
				toggled_on.emit()
			else:
				toggled_off.emit()
