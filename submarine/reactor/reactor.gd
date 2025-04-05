extends Node

@export var heat_indicators: Array[MeshInstance3D]
@export var power_indicators: Array[MeshInstance3D]
@export var particles: GPUParticles3D

const material_red: Material = preload("res://assets/materials/indicator_red.tres")
const material_green: Material = preload("res://assets/materials/indicator_green.tres")
const material_blue: Material = preload("res://assets/materials/indicator_blue.tres")
const material_off: Material = preload("res://assets/materials/indicator_off.tres")

const MAX_POWER: int = 5
const MAX_HEAT: int = 5

func reset_indicators() -> void:
	for i in len(heat_indicators):
		if i < Global.submarine.power:
			heat_indicators[i].material_override = material_red
		else:
			heat_indicators[i].material_override = material_off
	
	for i in len(power_indicators):
		if i < Global.submarine.power:
			power_indicators[i].material_override = material_blue
		else:
			power_indicators[i].material_override = material_off
	
	var amt := Global.submarine.power / float(MAX_POWER)
	particles.amount_ratio = amt

func _ready() -> void:
	print("Hello from reactor")
	reset_indicators()

func inc_power() -> void:
	if Global.submarine.power < MAX_POWER:
		Global.submarine.power += 1
		reset_indicators()

func dec_power() -> void:
	if Global.submarine.power > 0:
		Global.submarine.power -= 1
		reset_indicators()
