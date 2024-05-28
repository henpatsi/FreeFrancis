extends Node2D

@export var mouse_sensitivtiy_value_label: Label
@export var volume_value_label: Label


func _on_mouse_sensitivity_slider_value_changed(value: float) -> void:
	mouse_sensitivtiy_value_label.text = str(value).pad_decimals(1)
	Global.mouse_sensitivity_modifier = value


func _on_volume_slider_value_changed(value: float) -> void:
	volume_value_label.text = str(value)
	Global.volume = value
