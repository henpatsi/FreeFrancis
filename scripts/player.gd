extends CharacterBody3D

var rng = RandomNumberGenerator.new()

@export var footstep_audio_streams: Array[AudioStream]
@onready var footstep_audio_player: AudioStreamPlayer3D = $Feet/FootstepAudioPlayer
@export var footstep_distance: float = 50.0
var distance_moved: float = 0.0

@export var intro_lock_time: float = 8.0
var locked: bool = true

var speed: float = 5.0
var normal_speed: float = 5.0
var walking_speed: float = 2.5
const JUMP_VELOCITY: float = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var MOUSE_SENSITIVITY: float = 0.2
var mouse_movement: Vector2

@export var ray_distance: float = 3.0
var ray_collision_object: Object

@onready var ray_cast_3d: RayCast3D = $RotationHelper/Camera/RayCast3D
@onready var rotation_helper: Node3D = $RotationHelper
@onready var camera: Camera3D = $RotationHelper/Camera



var light = preload("res://scenes/light_source.tscn")



func _ready() -> void:
	speed = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	if locked:
		intro_lock_time -= delta
		if intro_lock_time < 0:
			locked = false
			speed = normal_speed
		return
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = camera.project_local_ray_normal(mouse_position) * ray_distance
	ray_cast_3d.force_raycast_update()
	ray_collision_object = ray_cast_3d.get_collider()

func _physics_process(delta: float) -> void:
	movement(delta)
	look()
	other()


func movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	if is_on_floor():
		distance_moved += abs(velocity.x) + abs(velocity.z)
		if distance_moved > footstep_distance:
			var audio_stream = footstep_audio_streams[randi_range(0, footstep_audio_streams.size() - 1)]
			footstep_audio_player.stream = audio_stream
			footstep_audio_player.play()
			distance_moved -= footstep_distance
			var lightInst = light.instantiate()
			add_child(lightInst)
			lightInst.start_light(0.2)


func look() -> void:
	self.rotate_y(deg_to_rad(-mouse_movement[0] * MOUSE_SENSITIVITY))
	rotation_helper.rotate_x(deg_to_rad(-mouse_movement[1] * MOUSE_SENSITIVITY))
	rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, deg_to_rad(-60), deg_to_rad(90))
	mouse_movement = Vector2.ZERO


func other() -> void:
	if Input.is_action_just_pressed("toggle_lock_cursor"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("interact"):
		if ray_collision_object and ray_collision_object.is_in_group("interactable"):
			ray_collision_object.interact()
		var lightInst = light.instantiate()
		add_child(lightInst)
		lightInst.start_light(2)
	if Input.is_action_just_pressed("mouse_left_click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Get mouse input
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_movement = event.relative


func event_action() -> void:
	if speed == normal_speed:
		speed = walking_speed
	else:
		speed = normal_speed
