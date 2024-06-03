extends RigidBody3D

@onready var character_body: CharacterBody3D = $"../Player/CharacterBody3D"

@onready var doctor_female: Node3D = $DoctorFemale

@export var rotate_speed = 3.0
var rad180: float = deg_to_rad(180)

var end_menu_scene = "res://scenes/levels/lose_menu.tscn"

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5

func _physics_process(delta: float) -> void:
	handle_rotation(delta)

func handle_rotation(delta) -> void:
	if character_body.global_position.x > position.x:
		rotation.y = lerp_angle(rotation.y, 0, rotate_speed * delta)
	else:
		rotation.y = lerp_angle(rotation.y, rad180, rotate_speed * delta)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not Global.godmode:
		get_tree().call_deferred("change_scene_to_file", end_menu_scene)
