extends SubmarineSystem
class_name SubmarineReactor

@export var power_indicator: Indicator
@export var heat_indicator: Indicator
@export var particles: GPUParticles3D
@export var explosion_sound: AudioStreamPlayer
@export var shutting_down_sound: AudioStreamPlayer
@export var needs_restart_sound: AudioStreamPlayer
@export var starting_sound: AudioStreamPlayer

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

var dead := false
func tick() -> void:
	if heat < max_heat:
		heat += 1
	elif heat > max_heat:
		heat -= 1
	
	if heat == MAX_TOTAL_HEAT and not dead:
		dead = true
		explosion_sound.play()
		Events.death_reactor_overheat.emit()
	
	refresh_visuals()

func _power_generated_changed() -> void:
	if Submarine.power_generated == 0:
		shutting_down_sound.play()

func _ready() -> void:
	refresh_visuals()
	Submarine.power_unit_consumed.connect(refresh_visuals)
	Submarine.power_unit_released.connect(refresh_visuals)
	Submarine.power_generated_changed.connect(_power_generated_changed)

func inc_value() -> void:
	if Submarine.power_generated == 0:
		needs_restart_sound.play()
		return
	
	if Submarine.power_generated < power_indicator.diode_count:
		Submarine.power_generated += 1
	refresh_visuals()

func dec_value() -> void:
	if Submarine.power_generated > 0:
		Submarine.power_generated -= 1
	refresh_visuals()

func restart_reactor() -> void:
	starting_sound.play()
	Submarine.power_generated = 15
	for i in 3:
		Submarine.consume_power_unit(Submarine.life_support)
	
	for i in 3:
		Submarine.consume_power_unit(Submarine.sonar)
	refresh_visuals()
