extends MeshInstance3D

@export var break_force: float = 10
@export var destroyed_scene: PackedScene

var rng = RandomNumberGenerator.new()
var angle_rot: float = 5

func destroy(hit_force: float) -> void:
	var destroyed_scene_instance = destroyed_scene.instantiate()
	get_node("/root/Level").add_child(destroyed_scene_instance)
	destroyed_scene_instance.global_position = global_position
	var children = destroyed_scene_instance.get_children()
	for child in children:
		child.linear_velocity.y = hit_force * break_force
		child.angular_velocity.x = rng.randf_range(-angle_rot, angle_rot)
		child.angular_velocity.z = rng.randf_range(-angle_rot, angle_rot)
		child.angular_velocity.y = rng.randf_range(-angle_rot, angle_rot)
	queue_free()
