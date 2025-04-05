extends SubmarineSystem
class_name SubmarineLight

@export var alarm: AudioStreamPlayer3D
@export var light: OmniLight3D

var enabled := true
var powered := false
var lit := false

func _ready() -> void:
	light.light_energy = 0.0

func power_unit_drained() -> void:
	powered = false

func power_unit_provided() -> void:
	powered = true

func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

func tick() -> void:
	if enabled and not powered:
		Submarine.consume_power_unit(self)
	elif not enabled and powered:
		Submarine.release_power_unit(self)
	
	if powered and not lit:
		lit = true
		light.light_energy = 1.0
		light.light_color = Color.WHITE
	elif not powered and lit and not enabled:
		lit = false
		light.light_energy = 0.33
		light.light_color = Color.BLUE
	elif enabled and not powered:
		light.light_energy = 0.33
		light.light_color = Color.RED
