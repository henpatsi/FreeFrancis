extends Node3D

@onready var character_body_3d: CharacterBody3D = $"../.."
@onready var iv_collision_shape_3d: CollisionShape3D = $IVCollisionShape3D

var max_vertical_offset: float = 1.6
var min_vertical_offset: float = 0.7

var move_amount: Vector3
var target_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_amount *= delta
	target_position = position + move_amount

	limit_to_distance()
	check_collision()

	position = target_position
	move_amount = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		move_amount = Vector3(0, -event.relative.y, 0)

func check_collision() -> void:
	var total_move_amount = move_amount + character_body_3d.get_delta_pos()
	var ray_origin = self.global_position + (Vector3.DOWN * iv_collision_shape_3d.shape.height / 2)
	var ray_target_position = ray_origin + total_move_amount

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		print(result)
		target_position.y = 1
		if character_body_3d.velocity.y < 5:
			character_body_3d.velocity.y += min(-total_move_amount.y * 10, 5)

func limit_to_distance() -> void:
	target_position.y = clamp(target_position.y, min_vertical_offset, max_vertical_offset)
