extends Node3D

@onready var sewer_checkpoint: Node3D = $"../../../Areas/SewerCheckpoint"

var triggered: bool = false

@export var move_speed: float = 10
@onready var original_x: float = position.x
@export var reset_distance: float = 250

@onready var sound_effect_players: Node3D = $SoundEffectPlayers

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !triggered:
		return

	position.x += move_speed * delta
	if position.x >= original_x + reset_distance:
		position.x = original_x


func start_water() -> void:
	triggered = true
	for child in sound_effect_players.get_children():
		child.play()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.global_position = sewer_checkpoint.global_position
	if body.is_in_group("Enemy"):
		body.queue_free()
