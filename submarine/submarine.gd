extends Node
class_name Submarine

var power := 0
var oxygen := 0
var temperature := 0

func _ready() -> void:
	print("hello from sub")
	Global.submarine = self
