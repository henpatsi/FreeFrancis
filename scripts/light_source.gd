extends Node3D

var maximum_energy: float
var maximum_reached: bool = false

var light_started: bool = false

@onready var omni_light_3d: OmniLight3D = $OmniLight3D

func _ready() -> void:
	$".".set_as_top_level(true)

func _process(delta: float) -> void:
	
	if !light_started:
		return
	
	if !maximum_reached:
		omni_light_3d.light_energy += delta
		if omni_light_3d.light_energy > maximum_energy:
			maximum_reached = true
		return
	
	if omni_light_3d.light_energy > 0:
		omni_light_3d.light_energy -= delta
	else:
		queue_free()

func start_light(maximum: float):
	maximum_energy = maximum
	light_started = true
