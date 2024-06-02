extends Node3D

@onready var break_sound_effect_player: AudioStreamPlayer = $BreakSoundEffectPlayer
@onready var pieces: Node3D = $Pieces

var rng = RandomNumberGenerator.new()
var angle_rot: float = 5

var break_force: float = 10

func init_object(hit_force: float) -> void:
	for child in pieces.get_children():
		child.linear_velocity.y = hit_force * break_force
		child.angular_velocity.x = rng.randf_range(-angle_rot, angle_rot)
		child.angular_velocity.z = rng.randf_range(-angle_rot, angle_rot)
		child.angular_velocity.y = rng.randf_range(-angle_rot, angle_rot)
	break_sound_effect_player.play()

