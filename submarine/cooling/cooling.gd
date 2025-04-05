extends SubmarineSystem
class_name SubmarineCooling

var _value: int = 0
var value: int:
	get:
		return _value
	set(v):
		_value = v
		temp_change = -v * 5

const MAX_VALUE: int = 5

func drain_power() -> void:
	value -= 1

func inc_cooling() -> void:
	if value < MAX_VALUE and Global.submarine.reactor.draw_power(self):
		value += 1

func dec_cooling() -> void:
	if value > 0 and Global.submarine.reactor.release_power(self):
		value -= 1
