extends Node3D

@onready var character_body: CharacterBody3D = $"../CharacterBody3D"
@onready var pole_mesh: MeshInstance3D = $Pole
@onready var iv_armature_node: Node3D = $"../CharacterBody3D/Armature/IVHorizontalPos"

@export var sensitivity: float = 0.5
@export var jump_multiplier: float = 5
@export var max_jump: float = 3

@export var shoulder_height: float = 1.0
@export var max_vertical_offset: float = 1
@export var min_vertical_offset: float = -1

var mouse_input: Vector3
var move_amount: Vector3
var target_position: Vector3


func _process(delta: float) -> void:
	move_amount = mouse_input * delta * sensitivity
	target_position = global_position + move_amount + character_body.get_delta_pos()

	move_with_player_model()
	limit_to_distance()
	check_collision()

	global_position = target_position
	mouse_input = Vector3.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = Vector3(event.relative.x, -event.relative.y, 0) * Global.mouse_sensitivity_modifier


func move_with_player_model() -> void:
	target_position.x = iv_armature_node.global_position.x
	target_position.z = iv_armature_node.global_position.z
	global_rotation = iv_armature_node.global_rotation


func limit_to_distance() -> void:
	var arm_y: float = character_body.global_position.y + shoulder_height
	var arm_offset: float = target_position.y - arm_y
	if arm_offset > max_vertical_offset:
		target_position.y -= arm_offset - max_vertical_offset
	if arm_offset < min_vertical_offset:
		target_position.y += min_vertical_offset - arm_offset


func check_collision() -> void:
	var ray_origin = self.global_position + (Vector3.DOWN * pole_mesh.mesh.height / 2) + (Vector3.UP * 0.1)
	var ray_target_position = ray_origin + move_amount + character_body.get_delta_pos() + (Vector3.DOWN * 0.1)

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target_position)
	query.collide_with_bodies = true
	query.exclude = [character_body.get_rid()]
	var result = space_state.intersect_ray(query)
	if result:
		#print(result)
		target_position.y = result.position.y + 0.01 + (pole_mesh.mesh.height / 2) + -move_amount.y
		if character_body.velocity.y < 5:
			character_body.velocity.y += min(-move_amount.y * jump_multiplier, max_jump)
