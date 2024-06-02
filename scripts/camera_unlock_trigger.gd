extends Node3D

@export var player_camera: Camera3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_camera.set_y_lock(false)
