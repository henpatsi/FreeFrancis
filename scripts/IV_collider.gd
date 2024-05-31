extends CollisionShape3D

@onready var iv_drip: Node3D = $"../../IVDrip"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = iv_drip.global_position
