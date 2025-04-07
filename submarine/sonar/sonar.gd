extends SubmarineSystem
class_name SubmarineSonar

@export var viewport: SubViewport
@export var displayMesh: MeshInstance3D
@export var indicator: Indicator

func _ready() -> void:
	var mat: StandardMaterial3D = displayMesh.mesh.surface_get_material(1)
	mat.albedo_texture = viewport.get_texture()
	mat.albedo_color = Color.WHITE
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	_refresh_visuals()

func _refresh_visuals() -> void:
	for i in indicator.diode_count:
		indicator.set_diode(i, Indicator.DiodeColor.OFF)
	
	var sub := Submarine.submarine2d
	for i in sub.sonar_power:
		indicator.set_diode(i, Indicator.DiodeColor.GREEN)

func _inc_sonar() -> void:
	if Submarine.submarine2d.sonar_power < 3:
		Submarine.consume_power_unit(self)

func _dec_sonar() -> void:
	if Submarine.submarine2d.sonar_power > 0:
		Submarine.release_power_unit(self)

func power_unit_drained() -> void:
	Submarine.submarine2d.sonar_power -= 1
	_refresh_visuals()

func power_unit_provided() -> void:
	Submarine.submarine2d.sonar_power += 1
	_refresh_visuals()
