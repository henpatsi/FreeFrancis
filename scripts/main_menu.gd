extends Node2D

var level_scene = "res://scenes/levels/level_test.tscn"

func _ready():
	pass

func _on_start_button_pressed():
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file(level_scene)

func _on_exit_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
