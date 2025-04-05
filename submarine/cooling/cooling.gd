extends SubmarineSystem
class_name SubmarineCooling

var value: int = 0
const MAX_VALUE: int = 5

func drain_power() -> void:
	value -= 1

func inc_cooling() -> void:
	if value < MAX_VALUE and Global.submarine.reactor.draw_power(self):
		value += 1

func dec_cooling() -> void:
	if value > 0 and Global.submarine.reactor.release_power(self):
		value -= 1

func tick() -> void:
	Global.submarine.reactor.heat -= value * 3
	if Global.submarine.reactor.heat < 0:
		Global.submarine.reactor.heat = 0
	Global.submarine.reactor.reset_indicators()
