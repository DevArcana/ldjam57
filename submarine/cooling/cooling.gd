extends SubmarineSystem
class_name SubmarineCooling

func power_unit_drained() -> void:
	pass

func power_unit_provided() -> void:
	pass

func inc_cooling() -> void:
	Submarine.consume_power_unit(self)

func dec_cooling() -> void:
	Submarine.release_power_unit(self)
