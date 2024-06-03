extends Node2D

var main_menu_scene = "res://scenes/levels/main_menu.tscn"
var level_scene = "res://scenes/levels/level_final.tscn"

func _ready() -> void:
	var timer_value_label = get_node_or_null("Timer/ValueLabel")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if timer_value_label:
		timer_value_label.text = str(Global.timer).pad_decimals(2)
		timer_value_label.text += " seconds"

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file(level_scene)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
