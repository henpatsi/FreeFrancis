extends MeshInstance3D

@export var destroyed_scene: PackedScene

func destroy(hit_force: float) -> void:
	var destroyed_scene_instance = destroyed_scene.instantiate()
	get_node("/root/Level").add_child(destroyed_scene_instance)
	destroyed_scene_instance.global_position = global_position
	destroyed_scene_instance.init_object(hit_force)
	queue_free()
