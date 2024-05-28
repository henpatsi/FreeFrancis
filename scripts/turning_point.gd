extends MeshInstance3D

@export var turn_amount: float = 90

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.turn_player(turn_amount, global_position)
		queue_free()
