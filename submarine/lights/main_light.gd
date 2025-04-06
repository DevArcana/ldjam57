extends SubmarineSystem
class_name SubmarineLight

@export var alarm_reactor: AudioStreamPlayer3D
@export var alarm_oxygen: AudioStreamPlayer3D
@export var light: OmniLight3D

enum Mode {
	OFF,
	POWERED,
	ALARM
}

var _mode: Mode = Mode.OFF
var mode: Mode:
	get:
		return _mode
	set(m):
		if _mode == m:
			return
		
		if _mode == Mode.ALARM:
			alarm_reactor.stop()
			alarm_oxygen.stop()
		
		_mode = m
		
		if m == Mode.OFF:
			light.light_energy = 0.2
			light.light_color = Color.BLUE
		elif m == Mode.POWERED:
			light.light_energy = 1.0
			light.light_color = Color.WHITE
		elif m == Mode.ALARM:
			light.light_energy = 1.0
			light.light_color = Color.RED

var enabled: bool = false

func _on_power_unit_generated() -> void:
	if enabled and mode == Mode.OFF:
		Submarine.consume_power_unit(self)

func _ready() -> void:
	mode = Mode.OFF
	Submarine.power_unit_generated.connect(_on_power_unit_generated)

func power_unit_drained() -> void:
	mode = Mode.OFF

func power_unit_provided() -> void:
	mode = Mode.POWERED

func enable() -> void:
	enabled = true
	Submarine.consume_power_unit(self)

func disable() -> void:
	enabled = false
	Submarine.release_power_unit(self)

var timer := 0.0
func _process(delta: float) -> void:
	if mode == Mode.ALARM:
		timer += delta * 2.5
		if timer > 2 * PI:
			timer -= 2* PI
		light.light_energy = 0.5 + 0.5 * abs(sin(timer))
	else:
		timer = 0.0

var is_reactor_overheating := false
var is_oxygen_low := false

func tick() -> void:
	is_reactor_overheating = Submarine.reactor.max_heat >= Submarine.reactor.MAX_TOTAL_HEAT
	is_oxygen_low = Submarine.oxygen < 18
	
	if mode != Mode.OFF:
		if is_reactor_overheating or is_oxygen_low:
			mode = Mode.ALARM
			if is_reactor_overheating and not alarm_reactor.playing:
				alarm_reactor.play()
			if is_oxygen_low and not alarm_oxygen.playing:
				alarm_oxygen.play()
		else:
			mode = Mode.POWERED
