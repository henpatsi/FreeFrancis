extends Node3D

var triggered: bool = false

var water_scene: PackedScene = load("res://scenes/sewer_water.tscn")
var instance_spawned: bool = false

@export var move_speed: float = 10
@onready var original_position: Vector3 = global_position
@export var travel_distance: float = 400
@export var reset_distance: float = 250

@onready var sound_effect_players: Node3D = $SoundEffectPlayers


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !triggered:
		return

	position.x += move_speed * delta
	if position.x >= original_position.x + reset_distance and not instance_spawned:
		var water_instance = water_scene.instantiate()
		get_node("/root/Level").add_child(water_instance)
		water_instance.global_position = original_position
		water_instance.original_position = original_position
		water_instance.start_water()
		instance_spawned = true

	if position.x >= original_position.x + travel_distance:
		queue_free()

func start_water() -> void:
	triggered = true
	for child in sound_effect_players.get_children():
		child.play()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.reset_to_sewer_checkpoint()
	if body.is_in_group("Enemy"):
		body.queue_free()
