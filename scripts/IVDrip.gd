extends Node3D

@onready var character_body_3d: CharacterBody3D = $".."
@onready var area_3d: Area3D = $Area3D

var max_distance_from_player: float = 2.0
var distance_moved: Vector2

var collisions: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance_vector: Vector3 = area_3d.global_position - character_body_3d.global_position
	var distance_magnitude: float = abs(distance_vector.length())
	if distance_magnitude > max_distance_from_player:
		var move_back_distance_vector: Vector3 = distance_vector * ((distance_magnitude - max_distance_from_player) / distance_magnitude)
		move_back_distance_vector.z = 0
		area_3d.global_position -= move_back_distance_vector

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		area_3d.position += Vector3(event.relative.x, -event.relative.y, 0) * 0.01
		distance_moved.x = event.relative.x
		distance_moved.y = -event.relative.y

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Collided with: ", body.name)
	collisions += 1
	if collisions == 1:
		var jump_height = min(-distance_moved.y * 0.1, 5)
		character_body_3d.velocity.y += jump_height

func _on_area_3d_body_exited(body: Node3D) -> void:
	collisions -= 1
