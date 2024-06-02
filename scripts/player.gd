extends CharacterBody3D

var settings_scene = preload("res://scenes/levels/settings.tscn")

@onready var player: Node3D = $".."

@onready var armature: Node3D = $rig_002
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

@onready var last_pos: Vector3 = self.position
var delta_pos: Vector3 = Vector3.ZERO

var move_input: Vector2

@export var acceleration = 7
@export var deceleration = 12
@export var max_move_speed = 5.0
@export var rotate_speed = 3.0

var rad180: float = deg_to_rad(180)

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		open_pause_menu()
	
	delta_pos = self.position - last_pos
	last_pos = self.position


func _physics_process(delta: float) -> void:
	handle_vertical_movement(delta)
	handle_horizontal_movement(delta)
	handle_rotation(delta)

	move_and_slide()


func handle_vertical_movement(delta) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		animation_tree.set("parameters/conditions/air", true)
	else:
		if animation_tree.get("parameters/conditions/air"):
			if animation_tree.get("parameters/conditions/running"):
				animation_state.travel("Run")
			else:
				animation_state.travel("Idle")
		animation_tree.set("parameters/conditions/air", false)


func handle_horizontal_movement(delta) -> void:
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_dir := (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	if move_dir:
		velocity.x = move_toward(velocity.x, move_dir.x * max_move_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)

	if abs(velocity.x) > 0:
		animation_tree.set("parameters/conditions/running", true)
		animation_tree.set("parameters/conditions/stopped", false)
	else:
		animation_tree.set("parameters/conditions/stopped", true)
		animation_tree.set("parameters/conditions/running", false)
	
	#var anim_velocity = velocity * armature.transform.basis
	#animation_tree.set("parameters/Idle-Run/blend_position", anim_velocity.x * 20)


func handle_rotation(delta) -> void:
	if move_input.x > 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, 0, rotate_speed * delta)
	elif move_input.x < 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, -rad180, rotate_speed * delta)


func open_pause_menu() -> void:
	var settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
	settings_instance.lock_mouse_on_exit = true


func get_delta_pos() -> Vector3:
	return delta_pos


func jump(force: float, max_force: float) -> void:
	if force == 0:
		return

	velocity.y = min(velocity.y + force, max_force)
	if not animation_tree.get("parameters/conditions/air"):
		animation_state.travel("StartJump")
		animation_tree.set("parameters/conditions/air", true)
