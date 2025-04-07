extends RigidBody2D
class_name Submarine2D

@export var scanner: Area2D
@export var scanner_mesh: MeshInstance2D
@export var scanner_collider: CollisionShape2D

var _sonar_power: int = 0

## Sonar power from 0 to 3 inclusive
var sonar_power: int:
	get:
		return _sonar_power
	set(value):
		_sonar_power = value
		sonar_speed = float(value)
		
		var sonar_len := 16.0 * pow(2, value)
		scanner_mesh.mesh.size.y = sonar_len
		scanner_mesh.position.y = -(sonar_len/2)
		scanner_collider.shape.size.y = sonar_len
		scanner_collider.position.y = -(sonar_len/2)

var sonar_speed: float = 0.0

var forward: int = 0
var turn: float = 0

func _ready() -> void:
	Submarine.submarine2d = self

func _physics_process(delta: float) -> void:
	scanner.rotate(delta * sonar_speed)
	apply_force(Vector2(0.0, -forward * 1000).rotated(rotation))
	apply_torque(turn)
	turn = lerpf(turn, 0.0, delta)
	DebugDraw2D.set_text("turn", turn)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Scannable:
		body.reveal()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Scannable:
		body.stop_reveal()


func _on_body_entered(body: Node) -> void:
	if body is Rock:
		Submarine.power_generated = 0
