extends Node2D

var loading_scene = "res://scenes/levels/loading.tscn"

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file(loading_scene)
