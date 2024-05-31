extends Node3D

@onready var character_body: CharacterBody3D = $"../CharacterBody3D"
@onready var pole_mesh: MeshInstance3D = $Pole
@onready var iv_armature_node: Node3D = $"../CharacterBody3D/rig_001/IVHorizontalPos"

@onready var left_hand_ik: SkeletonIK3D = $"../CharacterBody3D/rig_001/Skeleton3D/left_hand_IK"
@onready var right_hand_ik: SkeletonIK3D = $"../CharacterBody3D/rig_001/Skeleton3D/right_hand_IK"
@onready var head_ik: SkeletonIK3D = $"../CharacterBody3D/rig_001/Skeleton3D/head_IK"
@onready var head_ik_target: Node3D = $IKPositions/HeadPosition

@export var head_rotation_zero: float = 30
@export var head_rotation_up: float = 40
@export var head_rotation_down: float = 20
@onready var head_rotation_range = head_rotation_up + head_rotation_down

@export var sensitivity: float = 0.3
@export var jump_multiplier: float = 5
@export var max_jump: float = 8

@export var shoulder_height: float = 1
@export var max_vertical_offset: float = 0.6
@export var min_vertical_offset: float = -0.4
@onready var height_range = max_vertical_offset + -min_vertical_offset
var arm_y: float
var arm_offset: float

var mouse_input: Vector3
var move_amount: Vector3
var target_position: Vector3


func _ready() -> void:
	left_hand_ik.start()
	right_hand_ik.start()
	head_ik.start()


func _process(delta: float) -> void:
	move_amount = mouse_input * delta * sensitivity
	target_position = global_position + move_amount + character_body.get_delta_pos()

	move_with_player_model()
	limit_to_distance()
	check_bottom_collision()
	check_top_collision()

	global_position = target_position
	mouse_input = Vector3.ZERO

	update_player_head_rotation()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = Vector3(event.relative.x, -event.relative.y, 0) * Global.mouse_sensitivity_modifier


func move_with_player_model() -> void:
	target_position.x = iv_armature_node.global_position.x
	target_position.z = iv_armature_node.global_position.z
	global_rotation = iv_armature_node.global_rotation


func limit_to_distance() -> void:
	arm_y = character_body.global_position.y + shoulder_height
	arm_offset = target_position.y - arm_y
	if arm_offset > max_vertical_offset:
		target_position.y -= arm_offset - max_vertical_offset
	if arm_offset < min_vertical_offset:
		target_position.y += min_vertical_offset - arm_offset


func check_bottom_collision() -> void:
	var ray_origin: Vector3 = global_position + (Vector3.DOWN * pole_mesh.mesh.height / 2) + (Vector3.UP * 0.1)
	var ray_target_position: Vector3 = target_position + (Vector3.DOWN * pole_mesh.mesh.height / 2)

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	query.exclude = [character_body.get_rid()]
	var result: Dictionary = space_state.intersect_ray(query)
	if result:
		#print(result)
		target_position.y = result.position.y + 0.01 + (pole_mesh.mesh.height / 2)
		limit_to_distance()
		if character_body.velocity.y < max_jump:
			var jump_amount = -move_amount.y * jump_multiplier
			character_body.velocity.y = min(character_body.velocity.y + jump_amount, max_jump)
		print(character_body.velocity.y)
		if move_amount.y < -0.2 and result.collider.is_in_group("PlayerDestructable"):
			result.collider.get_parent().queue_free()


func check_top_collision() -> void:
	var ray_origin: Vector3 = global_position + (Vector3.UP * pole_mesh.mesh.height / 2) + (Vector3.DOWN * 0.1)
	var ray_target_position: Vector3 = target_position + (Vector3.UP * pole_mesh.mesh.height / 2)
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	query.exclude = [character_body.get_rid()]
	var result: Dictionary = space_state.intersect_ray(query)
	if result:
		#print(result)
		target_position.y = result.position.y - 0.01 - (pole_mesh.mesh.height / 2)
		limit_to_distance()
		if move_amount.y > 0.2 and result.collider.is_in_group("PlayerDestructable"):
			result.collider.get_parent().queue_free()


func update_player_head_rotation() -> void:
	var height_ratio = (arm_offset + -min_vertical_offset) / height_range
	head_ik_target.rotation.x = deg_to_rad(1 - (head_rotation_range * height_ratio) + head_rotation_zero)
