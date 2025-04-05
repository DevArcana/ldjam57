extends StaticBody3D
class_name Interactable

@export var meshes: Array[MeshInstance3D]

const highlight_material: Material = preload("res://assets/materials/interactive_outline.tres")

func focus() -> void:
	for mesh in meshes:
		mesh.material_overlay = highlight_material

func unfocus() -> void:
	for mesh in meshes:
		mesh.material_overlay = null

## override this
func interact_start() -> void:
	pass

## override this
func interact_stop() -> void:
	pass
