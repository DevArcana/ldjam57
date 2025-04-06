extends Node
class_name Indicator

const material_red: Material = preload("res://assets/materials/indicator_red.tres")
const material_green: Material = preload("res://assets/materials/indicator_green.tres")
const material_blue: Material = preload("res://assets/materials/indicator_blue.tres")
const material_off: Material = preload("res://assets/materials/indicator_off.tres")

enum DiodeColor {
	RED,
	GREEN,
	BLUE,
	OFF
}

var _indicators: Array[MeshInstance3D]

var diode_count: int:
	get:
		return len(_indicators)

func _ready() -> void:
	for c in get_children():
		var mesh := c as MeshInstance3D
		assert(mesh != null)
		_indicators.append(mesh)

## Sets the selected diode to selected color.
func set_diode(i: int, color: DiodeColor) -> void:
	var diode := _indicators[i]
	assert(diode != null)
	
	if color == DiodeColor.RED:
		diode.material_override = material_red
	elif color == DiodeColor.GREEN:
		diode.material_override = material_green
	elif color == DiodeColor.BLUE:
		diode.material_override = material_blue
	elif color == DiodeColor.OFF:
		diode.material_override = material_off
