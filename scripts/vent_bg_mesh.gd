extends MeshInstance3D

@onready var character_body_3d: CharacterBody3D = $"../../../../Player/CharacterBody3D"

var is_visible: bool = false

func _process(delta: float) -> void:
	if is_visible:
		return
	
	if global_position.distance_to(character_body_3d.global_position) < 20:
		visible = true
		is_visible = true
