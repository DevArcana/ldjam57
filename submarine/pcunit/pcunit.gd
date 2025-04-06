extends Node3D

@export var viewport: SubViewport
@export var displayMesh: MeshInstance3D

func _ready() -> void:
	displayMesh.mesh.surface_get_material(1).albedo_texture = viewport.get_texture()
