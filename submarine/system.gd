extends Node
class_name SubmarineSystem

## Called when a unit of power is taken from a system.
## Including when release_power_unit was called.
func power_unit_drained() -> void:
	pass

## Called when a unit of power is provided to a system.
## Including when consume_power_unit was called.
func power_unit_provided() -> void:
	pass

## Called every ship tick.
func tick() -> void:
	pass
