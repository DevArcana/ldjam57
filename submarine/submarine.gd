extends Node

#region Systems
var reactor: SubmarineReactor
var cooling: SubmarineCooling
#endregion

#region Power
var _power_generated: int = 0
var _power_consumed_units: Array[SubmarineSystem] = []

## Emitted whenever consume_power_unit returns true.
signal power_unit_consumed

## Emitted whenever release_power_unit returns true.
signal power_unit_released

## Number of power units currently produced by the reactor.
var power_generated: int:
	get:
		return _power_generated
	set(value):
		_power_generated = value
		
		while power_generated < power_consumed:
			(_power_consumed_units.pop_front() as SubmarineSystem).power_unit_drained()

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
