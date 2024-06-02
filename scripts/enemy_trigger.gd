extends Node3D

@export var enemy_spawn_location: Vector3

var enemy_scene = preload("res://scenes/enemy.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var enemy_instance = enemy_scene.instantiate()
		get_node("/root/Level").add_child(enemy_instance)
		enemy_instance.global_position = enemy_spawn_location
		queue_free()
