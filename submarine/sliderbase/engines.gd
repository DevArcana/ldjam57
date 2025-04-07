extends SubmarineSystem
class_name SubmarineEngines

@export var indicator: Indicator

var _slider_value: int = 0
var slider_value: int:
	get:
		return _slider_value
	set(value):
		if _slider_value == value:
			return
		_slider_value = value
		_sync_level()

func _sync_level() -> void:
	var sub := Submarine.submarine2d
	
	if slider_value == sub.forward:
		return
	
	while sub.forward > 0 and slider_value < sub.forward:
		Submarine.release_power_unit(self)
	
	if sub.forward < 0 and slider_value != -1:
		Submarine.release_power_unit(self)
		
	if sub.forward == 0 and slider_value == -1:
		Submarine.consume_power_unit(self)
	
	if slider_value > 0 and sub.forward < slider_value:
		Submarine.consume_power_unit(self)

func _refresh_visuals() -> void:
	for i in indicator.diode_count:
		indicator.set_diode(i, Indicator.DiodeColor.OFF)
	
	var sub := Submarine.submarine2d
	var fw := sub.forward
	if fw > 0:
		for i in fw:
			indicator.set_diode(i + 2, Indicator.DiodeColor.BLUE)
	elif fw < 0:
			indicator.set_diode(0, Indicator.DiodeColor.RED)
				

#
#func _refresh_sonar_visuals() -> void:
	#for i in sonar_indicator.diode_count:
		#sonar_indicator.set_diode(i, Indicator.DiodeColor.OFF)
	#
	#for i in Submarine.submarine2d.sonar_power:
		#sonar_indicator.set_diode(i, Indicator.DiodeColor.GREEN)

func _ready() -> void:
	_refresh_visuals()

func power_unit_drained() -> void:
	Submarine.submarine2d.forward += sign(-Submarine.submarine2d.forward)
	_refresh_visuals()

func power_unit_provided() -> void:
	Submarine.submarine2d.forward += sign(slider_value)
	_refresh_visuals()

func _physics_process(delta: float) -> void:
	_sync_level()
