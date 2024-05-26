extends Node3D

@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var arms: Node3D = $"../CharacterBody3D/Arms"
@onready var iv_collision_shape_3d: CollisionShape3D = $IVCollisionShape3D

var max_distance_from_player: float = 1.5

var move_amount: Vector3
var target_position: Vector3

var collisions: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_amount *= delta
	target_position = position + move_amount + character_body_3d.get_delta_pos()

	limit_to_distance()
	check_collision()

	position = target_position
	move_amount = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		move_amount = Vector3(event.relative.x, -event.relative.y, 0)

func check_collision() -> void:
	var ray_origin = self.global_position + (Vector3.DOWN * iv_collision_shape_3d.shape.height / 2)
	var ray_target_position = ray_origin + move_amount + character_body_3d.get_delta_pos()

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		print(result)
		target_position.y = result.position.y + 0.01
		if character_body_3d.velocity.y < 5:
			character_body_3d.velocity.y += min(-move_amount.y * 10, 5)

func limit_to_distance() -> void:
	var arm_position = Vector3(character_body_3d.position.x, character_body_3d.position.y + 1, target_position.z)
	var distance_vector: Vector3 = target_position - arm_position
	var distance_magnitude: float = abs(distance_vector.length())
	if distance_magnitude > max_distance_from_player:
		var move_back_distance_vector: Vector3 = distance_vector * ((distance_magnitude - max_distance_from_player) / distance_magnitude)
		move_back_distance_vector.z = 0
		target_position -= move_back_distance_vector
