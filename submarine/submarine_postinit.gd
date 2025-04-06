extends Node

## This method will be called after all ship's systems.
func _ready() -> void:
	for i in 10:
		Submarine.reactor.inc_value()
	
	for i in 2:
		Submarine.consume_power_unit(Submarine.life_support)
