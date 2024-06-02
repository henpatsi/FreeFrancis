extends RigidBody3D

@onready var character_body: CharacterBody3D = $"../Player/CharacterBody3D"

@export var acceleration: float = 8
@export var max_speed: float = 4
@export var rotate_speed = 3.0
var rad180: float = deg_to_rad(180)

var move_dir: float

var end_menu_scene = "res://scenes/levels/lose_menu.tscn"


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5


func _physics_process(delta: float) -> void:
	
	handle_movement(delta)
	handle_rotation(delta)


func handle_movement(delta) -> void:
	if character_body.global_position.x > position.x:
		move_dir = 1
	else:
		move_dir = -1
	linear_velocity.x = move_toward(linear_velocity.x, move_dir * max_speed, acceleration * delta)


func handle_rotation(delta) -> void:
	if move_dir > 0:
		rotation.y = lerp_angle(rotation.y, 0, rotate_speed * delta)
	elif move_dir < 0:
		rotation.y = lerp_angle(rotation.y, rad180, rotate_speed * delta)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(end_menu_scene)
	else:
		var body_parent = body.get_parent()
		var target_position = body_parent.global_position + Vector3(0, 0, 3)
		var tween = get_tree().create_tween()
		tween.tween_property(body_parent, "global_position", target_position, 1)
