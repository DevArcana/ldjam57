extends Node

## This method will be called after all ship's systems.
func _ready() -> void:
	Submarine.reactor.inc_value()
