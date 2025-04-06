extends SubmarineSystem
class_name SubmarineReactor

@export var power_indicator: Indicator
@export var heat_indicator: Indicator
@export var particles: GPUParticles3D

var heat: int = 0
var max_heat: int = 0
const MAX_TOTAL_HEAT: int = 15

func refresh_visuals() -> void:
	for i in power_indicator.diode_count:
		if i < Submarine.power_consumed:
			power_indicator.set_diode(i, Indicator.DiodeColor.GREEN)
		elif i < Submarine.power_generated:
			power_indicator.set_diode(i, Indicator.DiodeColor.BLUE)
		else:
			power_indicator.set_diode(i, Indicator.DiodeColor.OFF)
	
	max_heat = max(Submarine.power_generated * 2 + Submarine.power_available + Submarine.external_heat_mod, 0)
	
	for i in heat_indicator.diode_count:
		if i < heat:
			heat_indicator.set_diode(i, Indicator.DiodeColor.RED)
		elif i < max_heat:
			heat_indicator.set_diode(i, Indicator.DiodeColor.BLUE)
		else:
			heat_indicator.set_diode(i, Indicator.DiodeColor.OFF)
	
	var amt := Submarine.power_generated / float(power_indicator.diode_count)
	particles.amount_ratio = amt

func tick() -> void:
	if heat < max_heat:
		heat += 1
	elif heat > max_heat:
		heat -= 1
	
	refresh_visuals()

func _ready() -> void:
	refresh_visuals()
	Submarine.power_unit_consumed.connect(refresh_visuals)
	Submarine.power_unit_released.connect(refresh_visuals)

func inc_value() -> void:
	if Submarine.power_generated < power_indicator.diode_count:
		Submarine.power_generated += 1
	refresh_visuals()

func dec_value() -> void:
	if Submarine.power_generated > 0:
		Submarine.power_generated -= 1
	refresh_visuals()
