extends Node

#region Systems
var reactor: SubmarineReactor
var light: SubmarineLight
var life_support: SubmarineLifeSupport
var engines: SubmarineEngines
var submarine2d: Submarine2D
var sonar: SubmarineSonar
#endregion

#region Power
var _power_generated: int = 0
var _power_consumed_units: Array[SubmarineSystem] = []

## Emitted whenever consume_power_unit returns true.
signal power_unit_consumed

## Emitted whenever release_power_unit returns true.
signal power_unit_released

## Emitted when a new power unit is generated.
signal power_unit_generated

## Emitted whenever the value of power_generated_changes.
signal power_generated_changed

## Number of power units currently produced by the reactor.
var power_generated: int:
	get:
		return _power_generated
	set(value):
		var added := value > _power_generated
		
		if _power_generated == value:
			return
		
		_power_generated = value
		
		if added:
			power_unit_generated.emit()
		elif _power_generated < len(_power_consumed_units):
			_power_generated = 0
		
		while power_generated < power_consumed:
			(_power_consumed_units.pop_front() as SubmarineSystem).power_unit_drained()
		
		power_generated_changed.emit()

## Number of power units currently consumed by all systems.
var power_consumed: int:
	get:
		return len(_power_consumed_units)

## Number of available power units.
var power_available: int:
	get:
		return power_generated - power_consumed

## Try to consume a unit of power.
func consume_power_unit(system: SubmarineSystem) -> bool:
	if power_available == 0:
		# exceeded power draw
		power_generated = 0
		return false
		
	_power_consumed_units.push_front(system)
	system.power_unit_provided()
	power_unit_consumed.emit()
	return true

## Release a consumed unit of power if the system is indeed consuming it.
func release_power_unit(system: SubmarineSystem) -> bool:
	for i in len(_power_consumed_units):
		if _power_consumed_units[i] == system:
			_power_consumed_units[i].power_unit_drained()
			_power_consumed_units.remove_at(i)
			power_unit_released.emit()
			return true
	
	return false
#endregion

#region Heat

## Amount of power units offset by external heat, -20 means that at 10 power gen and zero free units, the reactor won't heat up.
var external_heat_mod: int = -20

#endregion

#region Oxygen

## Number of oxygen units. At zero the player dies. Max is 36.
var oxygen: int = 18
const MAX_OXYGEN: int = 36

#endregion

#region Score

## Increased by picking up targets.
var score: int = 0

## The ship always knows the location of all targets and points at the nearest one.
var targets: Array[Target]

#endregion

func _tick() -> void:
	if reactor:
		reactor.tick()
	if light:
		light.tick()
	if life_support:
		life_support.tick()
	if engines:
		engines.tick()
	if sonar:
		sonar.tick()


var timer := 0.0
const TIME_PER_TICK := 1.0
func _physics_process(delta: float) -> void:
	timer += delta
	if timer > TIME_PER_TICK:
		timer = 0.0
		_tick()

func restart_game() -> void:
	# I HATE THIS CODE
	# Note to myself to never use autoload scripts for global state like this.
	oxygen = 18
	external_heat_mod = -20
	_power_generated = 0
	_power_consumed_units = []
	get_tree().reload_current_scene()
