extends SubmarineSystem
class_name SubmarineReactor

@export var heat_indicators: Array[MeshInstance3D]
@export var value_indicators: Array[MeshInstance3D]
@export var particles: GPUParticles3D

const material_red: Material = preload("res://assets/materials/indicator_red.tres")
const material_green: Material = preload("res://assets/materials/indicator_green.tres")
const material_blue: Material = preload("res://assets/materials/indicator_blue.tres")
const material_off: Material = preload("res://assets/materials/indicator_off.tres")

var value: int = 0
var drawing: Array[SubmarineSystem] = []

const MAX_VALUE: int = 5
const MAX_HEAT: int = 5

func reset_indicators() -> void:
	for i in len(heat_indicators):
		if i < value:
			heat_indicators[i].material_override = material_red
		else:
			heat_indicators[i].material_override = material_off
	
	for i in len(value_indicators):
		if i < value:
			if i < len(drawing):
				value_indicators[i].material_override = material_green
			else:
				value_indicators[i].material_override = material_blue
		else:
			value_indicators[i].material_override = material_off
	
	var amt := value / float(MAX_VALUE)
	particles.amount_ratio = amt
	
	var unused := value - len(drawing)
	temp_change = value * 2 + unused * 0.5

func _ready() -> void:
	reset_indicators()

func inc_value() -> void:
	if value < MAX_VALUE:
		value += 1
		reset_indicators()

func dec_value() -> void:
	if value > 0:
		value -= 1
		if len(drawing) > value:
			(drawing.pop_front() as SubmarineSystem).drain_power()
		reset_indicators()

## A system can draw a unit of power from the reactor if there is enough capacity.
func draw_power(system: SubmarineSystem) -> bool:
	if len(drawing) >= value:
		return false
	
	drawing.push_front(system)
	reset_indicators()
	return true

func release_power(system: SubmarineSystem) -> bool:
	# find the last instance of a given system in the stack
	for i in len(drawing):
		if drawing[i] == system:
			drawing.remove_at(i)
			reset_indicators()
			return true
	return false
