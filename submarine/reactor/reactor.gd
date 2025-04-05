extends SubmarineSystem
class_name SubmarineReactor

# Reactor produces units of power.
# Each produced unit of power generates 2 units of heat.
# Each unused unit of power produces additioanl unit of heat.

@export var heat_indicators: Array[MeshInstance3D]
@export var value_indicators: Array[MeshInstance3D]
@export var particles: GPUParticles3D

const material_red: Material = preload("res://assets/materials/indicator_red.tres")
const material_green: Material = preload("res://assets/materials/indicator_green.tres")
const material_blue: Material = preload("res://assets/materials/indicator_blue.tres")
const material_off: Material = preload("res://assets/materials/indicator_off.tres")

func refresh_visuals() -> void:
	for i in len(heat_indicators):
		heat_indicators[i].material_override = material_off
	
	for i in len(value_indicators):
		if i < Submarine.power_generated:
			if i < Submarine.power_consumed:
				value_indicators[i].material_override = material_green
			else:
				value_indicators[i].material_override = material_blue
		else:
			value_indicators[i].material_override = material_off
	
	var amt := Submarine.power_generated / float(len(value_indicators))
	particles.amount_ratio = amt

func _ready() -> void:
	refresh_visuals()
	Submarine.power_unit_consumed.connect(refresh_visuals)
	Submarine.power_unit_released.connect(refresh_visuals)

func inc_value() -> void:
	if Submarine.power_generated < len(value_indicators):
		Submarine.power_generated += 1
	refresh_visuals()

func dec_value() -> void:
	if Submarine.power_generated > 0:
		Submarine.power_generated -= 1
	refresh_visuals()
