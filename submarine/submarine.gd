extends Node
class_name Submarine

@export var reactor: SubmarineReactor
@export var cooling: SubmarineCooling

func _ready() -> void:
	Global.submarine = self

func adjust_temperature(system: SubmarineSystem, avg_temp: float, delta: float) -> void:
	system.temperature = lerp(system.temperature, avg_temp, abs(system.temperature-avg_temp)/avg_temp * delta)

func _physics_process(delta: float) -> void:
	var sum_temp := reactor.temperature + cooling.temperature
	var avg_temp := sum_temp / 2.0
	
	adjust_temperature(reactor, avg_temp, delta)
	adjust_temperature(cooling, avg_temp, delta)
	
	DebugDraw2D.set_text("power", "%s/%s" % [reactor.value, reactor.MAX_VALUE])
	DebugDraw2D.set_text("power draw", "%s/%s" % [len(reactor.drawing), reactor.MAX_VALUE])
	DebugDraw2D.set_text("reactor temp", reactor.temperature - reactor.ZERO_TEMP)
	DebugDraw2D.set_text("cooling temp", cooling.temperature - cooling.ZERO_TEMP)
	DebugDraw2D.set_text("ship temp", avg_temp - cooling.ZERO_TEMP)
	DebugDraw2D.set_text("cooling", "%s/%s" % [cooling.value, cooling.MAX_VALUE])
