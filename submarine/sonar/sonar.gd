extends Node3D

@export var viewport: SubViewport
@export var displayMesh: MeshInstance3D

func _ready() -> void:
	var mat: StandardMaterial3D = displayMesh.mesh.surface_get_material(1)
	mat.albedo_texture = viewport.get_texture()
	mat.albedo_color = Color.WHITE
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
