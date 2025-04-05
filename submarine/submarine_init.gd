extends Node

@export var reactor: SubmarineReactor
@export var cooling: SubmarineCooling

## This method will be called before all ship's subsystems so the singleton can be used.
func _ready() -> void:
	Submarine.reactor = reactor
	Submarine.cooling = cooling
