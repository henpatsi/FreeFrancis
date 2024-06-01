extends Node3D

var triggered: bool = false

@export var move_speed: float = 10
@onready var original_x: float = position.x
@export var reset_distance: float = 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !triggered:
		return

	position.x += move_speed * delta
	if position.x >= original_x + reset_distance:
		position.x = original_x


func start_water() -> void:
	triggered = true
