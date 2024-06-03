extends MeshInstance3D

@export var destroyed_scene: PackedScene
@export var force_to_destroy: float = 0.15

func try_destroy(hit_force: float) -> void:
	if abs(hit_force) < force_to_destroy:
		return
	var destroyed_scene_instance = destroyed_scene.instantiate()
	get_node("/root/Level").add_child(destroyed_scene_instance)
	destroyed_scene_instance.global_position = global_position
	destroyed_scene_instance.init_object(hit_force)
	queue_free()
