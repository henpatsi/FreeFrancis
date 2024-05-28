extends CharacterBody3D

@onready var player: Node3D = $".."

@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

@onready var left_arm_ik: SkeletonIK3D = $Armature/Skeleton3D/LeftArmIK
@onready var right_arm_ik: SkeletonIK3D = $Armature/Skeleton3D/RightArmIK

@onready var last_pos: Vector3 = self.position
var delta_pos: Vector3 = Vector3.ZERO

var move_input: Vector2

@export var acceleration = 0.1
@export var max_move_speed = 5.0
@export var rotate_speed = 3.0

var rad180: float = deg_to_rad(180)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	left_arm_ik.start()
	right_arm_ik.start()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_lock_cursor"):
		toggle_mouse_mode()
	if Input.is_action_just_pressed("rotate_right"):
		animation_state.travel("Flair")
	
	delta_pos = self.position - last_pos
	last_pos = self.position


func _physics_process(delta: float) -> void:

	handle_vertical_movement(delta)
	handle_horizontal_movement()
	handle_rotation(delta)

	move_and_slide()


func handle_vertical_movement(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		animation_tree.set("parameters/conditions/air", true)
		animation_tree.set("parameters/conditions/grounded", false)
	else:
		animation_tree.set("parameters/conditions/air", false)
		animation_tree.set("parameters/conditions/grounded", true)


func handle_horizontal_movement() -> void:
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_dir := (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	if move_dir:
		velocity.x = move_toward(velocity.x, move_dir.x * max_move_speed, acceleration)
		velocity.z = move_toward(velocity.z, move_dir.z * max_move_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.z = move_toward(velocity.z, 0, acceleration)
	
	var anim_velocity = velocity * armature.transform.basis
	animation_tree.set("parameters/IWR/blend_position", Vector2(anim_velocity.x, -anim_velocity.z) * 20)


func handle_rotation(delta) -> void:
	if move_input.x > 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, 0, rotate_speed * delta)
	elif move_input.x < 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, rad180, rotate_speed * delta)


func toggle_mouse_mode() -> void:
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func turn_player(amount: float, rot_pos: Vector3) -> void:
	velocity = Vector3.ZERO
	global_position.x = rot_pos.x
	global_position.z = rot_pos.z
	rotation = Vector3.UP * deg_to_rad(amount)


func get_delta_pos() -> Vector3:
	return delta_pos
