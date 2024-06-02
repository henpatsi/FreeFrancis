extends RigidBody3D

@export var move_speed: float = 4

var end_menu_scene = "res://scenes/levels/lose_menu.tscn"


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5


func _physics_process(delta: float) -> void:
	position.x += move_speed * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(end_menu_scene)
	else:
		var body_parent = body.get_parent()
		var target_position = body_parent.global_position + Vector3(0, 0, 3)
		var tween = get_tree().create_tween()
		tween.tween_property(body_parent, "global_position", target_position, 1)
