extends CharacterBody3D

@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

@onready var skeleton_ik_3d: SkeletonIK3D = $Armature/Skeleton3D/SkeletonIK3D

@onready var last_pos: Vector3 = self.position
var delta_pos: Vector3 = Vector3.ZERO

const ACCELERATION = 0.1
const MAX_MOVE_SPEED = 5.0
const ROTATE_SPEED = 3.0
const JUMP_VELOCITY = 4.5

var rad180: float = deg_to_rad(180)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	skeleton_ik_3d.start()

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
	var move_input := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_dir := (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	if move_dir:
		velocity.x = move_toward(velocity.x, move_dir.x * MAX_MOVE_SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, move_dir.z * MAX_MOVE_SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)
	
	var anim_velocity = velocity * armature.transform.basis
	animation_tree.set("parameters/IWR/blend_position", Vector2(anim_velocity.x, -anim_velocity.z) * 20)


func handle_rotation(delta) -> void:
	if velocity.x > 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, 0, ROTATE_SPEED * delta)
	elif velocity.x < 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, rad180, ROTATE_SPEED * delta)


func toggle_mouse_mode() -> void:
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_delta_pos() -> Vector3:
	return delta_pos
