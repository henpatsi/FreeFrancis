extends RigidBody3D

@export var move_speed: float = 3

var end_menu_scene = "res://scenes/levels/lose_menu.tscn"


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5


func _physics_process(delta: float) -> void:
	position.x += move_speed * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(end_menu_scene)
	elif body.is_in_group("Destructable"):
		body.get_parent().queue_free()
