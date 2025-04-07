extends Node

@export var reactor: SubmarineReactor
@export var light: SubmarineLight
@export var life_support: SubmarineLifeSupport
@export var engines: SubmarineEngines
@export var sonar: SubmarineSonar

## This method will be called before all ship's subsystems so the singleton can be used.
func _ready() -> void:
	Submarine.reactor = reactor
	Submarine.light = light
	Submarine.life_support = life_support
	Submarine.engines = engines
	Submarine.sonar = sonar
