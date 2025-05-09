extends Node

## This method will be called after all ship's systems.
func _ready() -> void:
	Submarine.power_generated = 1
	for i in 9:
		Submarine.reactor.inc_value()
	
	for i in 3:
		Submarine.consume_power_unit(Submarine.life_support)
	
	for i in 2:
		Submarine.consume_power_unit(Submarine.sonar)
