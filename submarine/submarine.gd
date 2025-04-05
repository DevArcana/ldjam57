extends Node
class_name Submarine

@export var reactor: SubmarineReactor
@export var cooling: SubmarineCooling

## how many seconds per tick
const SECONDS_PER_TICK: float = 1.0

func _ready() -> void:
	Global.submarine = self

func adjust_temperature(system: SubmarineSystem, avg_temp: float, delta: float) -> void:
	system.temperature = lerp(system.temperature, avg_temp, abs(system.temperature-avg_temp)/avg_temp * delta)

var timer: float = 0.0
func _physics_process(delta: float) -> void:
	timer += delta
	if timer > SECONDS_PER_TICK:
		timer = 0.0
		reactor.tick()
		cooling.tick()
	
	DebugDraw2D.set_text("reactor power (drawn/generated/total)", "%s/%s/%s" % [len(reactor.drawing), reactor.value, reactor.MAX_VALUE])
	DebugDraw2D.set_text("reactor heat (current/capacity)", "%s/%s" % [reactor.heat, reactor.heat_capacity])
	DebugDraw2D.set_text("cooling power (generated/total)", "%s/%s" % [cooling.value, cooling.MAX_VALUE])
