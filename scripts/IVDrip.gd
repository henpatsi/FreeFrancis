extends Node3D

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D

var mouse_stop_timer: float = 0.0
var mouse_stop_delay: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_stop_timer <= 0:
		rigid_body_3d.linear_velocity = Vector3.ZERO
		rigid_body_3d.angular_velocity = Vector3.ZERO
	else:
		mouse_stop_timer -= delta

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rigid_body_3d.apply_force(Vector3(event.relative.x, -event.relative.y, 0))
		mouse_stop_timer = mouse_stop_delay
