extends Node2D

var background_info_scene = "res://scenes/levels/background_info_screen.tscn"
var settings_scene = preload("res://scenes/levels/settings.tscn")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global.volume_db)


func _on_start_button_pressed():
	get_tree().change_scene_to_file(background_info_scene)


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	var settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
