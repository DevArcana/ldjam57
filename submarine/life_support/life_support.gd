extends SubmarineSystem
class_name SubmarineLifeSupport

@export var particles: GPUParticles3D
@export var indicator: Indicator
@export var oxygen: Indicator

const MAX_POWER: int = 3

var _power: int = 0
var power: int:
	get:
		return _power
	set(value):
		_power = value
		_refresh_visuals()

func _refresh_visuals() -> void:
	particles.amount_ratio = power / float(MAX_POWER)
	for i in indicator.diode_count:
		if i < power:
			indicator.set_diode(i, Indicator.DiodeColor.BLUE)
		else:
			indicator.set_diode(i, Indicator.DiodeColor.OFF)
	
	var oxygen_diodes := Submarine.oxygen / 3
	var oxygen_diode_mod := Submarine.oxygen % 3
	for i in oxygen.diode_count:
		if i < oxygen_diodes:
			oxygen.set_diode(i, Indicator.DiodeColor.BLUE)
		elif i == oxygen_diodes and oxygen_diode_mod == 1:
			oxygen.set_diode(i, Indicator.DiodeColor.RED)
		elif i == oxygen_diodes and oxygen_diode_mod == 2:
			oxygen.set_diode(i, Indicator.DiodeColor.GREEN)
		else:
			oxygen.set_diode(i, Indicator.DiodeColor.OFF)

func _ready() -> void:
	_refresh_visuals()

func power_unit_drained() -> void:
	power -= 1

func power_unit_provided() -> void:
	power += 1

func tick() -> void:
	# oxygen drain each tick is 2 points
	Submarine.oxygen = clamp(Submarine.oxygen - 2 + power, 0, Submarine.MAX_OXYGEN)
	_refresh_visuals()

func increment() -> void:
	if power < MAX_POWER:
		Submarine.consume_power_unit(self)

func decrement() -> void:
	if power > 0:
		Submarine.release_power_unit(self)
