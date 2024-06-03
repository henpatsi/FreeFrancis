extends Node2D

var level_scene = "res://scenes/levels/level_final.tscn"

func _ready() -> void:
	var timer = get_node("Timer")
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	get_tree().change_scene_to_file(level_scene)
