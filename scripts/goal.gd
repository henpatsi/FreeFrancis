extends MeshInstance3D

@export var next_scene_path: String

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_deferred("change_scene_to_file", next_scene_path)
