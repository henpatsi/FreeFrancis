extends Node2D

@export var mouse_sensitivity_value_label: Label
@export var mouse_sensitivity_slider: HSlider
@export var volume_value_label: Label
@export var volume_slider: HSlider

var lock_mouse_on_exit = false

var loading_scene = "res://scenes/levels/loading.tscn"

signal volume_changed

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_starting_values()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		close_settings()


func set_starting_values():
	mouse_sensitivity_value_label.text = str(Global.mouse_sensitivity_modifier).pad_decimals(1)
	mouse_sensitivity_slider.value = Global.mouse_sensitivity_modifier
	volume_value_label.text = str(round((Global.volume_db + 60) / 60 * 100))
	volume_slider.value = Global.volume_db


func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	mouse_sensitivity_value_label.text = str(value).pad_decimals(1)
	Global.mouse_sensitivity_modifier = value


func _on_volume_slider_value_changed(value: float) -> void:
	volume_value_label.text = str(round((value + 60) / 60 * 100))
	Global.volume_db = value
	volume_changed.emit()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_back_button_pressed() -> void:
	close_settings()


func close_settings() -> void:
	get_tree().paused = false
	if lock_mouse_on_exit:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file(loading_scene)
