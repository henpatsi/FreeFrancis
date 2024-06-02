extends Node2D

var level_scene = "res://scenes/levels/level_final.tscn"
var settings_scene = preload("res://scenes/levels/settings.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_start_button_pressed():
	get_tree().change_scene_to_file(level_scene)


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	var settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
