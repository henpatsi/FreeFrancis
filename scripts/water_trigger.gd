extends Node3D

@export var sewer_water: Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		sewer_water.start_water()
		queue_free()
