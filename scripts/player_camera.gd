extends Camera3D

@onready var character_body: CharacterBody3D = $"../CharacterBody3D"
@onready var player_offset: Vector3 = position - character_body.position

var target_position: Vector3
@export var y_locked: bool = true
var y_unlocking: bool = false
var unlock_speed: float = 2

func _physics_process(delta: float) -> void:

	smooth_unlock(delta)
	follow_player(delta)


func smooth_unlock(delta) -> void:
	if not y_unlocking:
		return
	
	var target_y = character_body.position.y + player_offset.y
	position.y = lerpf(position.y, target_y, unlock_speed * delta)
	
	if abs(position.y - target_y) < 0.1:
		y_unlocking = false
		y_locked = false


func follow_player(delta: float) -> void:
	target_position = character_body.position + player_offset
	
	if y_locked:
		target_position.y = position.y
		
	position = target_position


func set_y_lock(state: bool) -> void:
	if state == true:
		y_locked = true
		y_unlocking = false
	else:
		y_unlocking = true
