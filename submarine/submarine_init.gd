extends Node

@export var reactor: SubmarineReactor

## This method will be called before all ship's subsystems so the singleton can be used.
func _ready() -> void:
	Submarine.reactor = reactor
