extends Node3D

@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var iv_collision_shape_3d: CollisionShape3D = $IVCollisionShape3D

@onready var iv_armature_node: Node3D = $"../CharacterBody3D/Armature/IVHorizontalPos"

const SENSITIVITY: float = 0.5
const JUMP_FORCE_MULTIPLIER: float = 5
const MAX_JUMP: float = 3

var arm_height: float = 1.0

var max_vertical_offset: float = 1
var min_vertical_offset: float = -1

var move_amount: Vector3
var target_position: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_amount *= delta * SENSITIVITY
	
	target_position = global_position + move_amount + character_body_3d.get_delta_pos()
	
	target_position.x = iv_armature_node.global_position.x
	target_position.z = iv_armature_node.global_position.z
	
	global_rotation = iv_armature_node.global_rotation

	limit_to_distance()
	check_collision()

	global_position = target_position
	move_amount = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		move_amount = Vector3(0, -event.relative.y, 0)

func check_collision() -> void:
	var ray_origin = self.global_position + (Vector3.DOWN * iv_collision_shape_3d.shape.height / 2)
	var ray_target_position = ray_origin + move_amount + character_body_3d.get_delta_pos()

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		#print(result)
		target_position.y = result.position.y + 0.01 + (iv_collision_shape_3d.shape.height / 2)
		if character_body_3d.velocity.y < 5:
			character_body_3d.velocity.y += min(-move_amount.y * JUMP_FORCE_MULTIPLIER, MAX_JUMP)

func limit_to_distance() -> void:
	var arm_y: float = character_body_3d.global_position.y + arm_height
	var arm_offset: float = target_position.y - arm_y
	if arm_offset > max_vertical_offset:
		target_position.y -= arm_offset - max_vertical_offset
	if arm_offset < min_vertical_offset:
		target_position.y += min_vertical_offset - arm_offset
