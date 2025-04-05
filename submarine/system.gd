extends Node
class_name SubmarineSystem

var temperature: float = 273.0
var temp_change: float = 0.0
const ZERO_TEMP: float = 273.0
const MAX_TEMP: float = 373.0

func drain_power() -> void:
	pass

func _physics_process(delta: float) -> void:
	temperature += temp_change * delta
	temperature = clampf(temperature, 0.0, MAX_TEMP)
