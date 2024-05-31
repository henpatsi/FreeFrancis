extends CollisionShape3D

@onready var iv_drip: Node3D = $"../../IVDrip"

@onready var collider_offset: Vector3 = (Vector3.UP * shape.height / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = iv_drip.global_position + collider_offset
