extends RigidBody3D

@export var move_speed: float = 3


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 5

func _physics_process(delta: float) -> void:
	position.x += move_speed * delta


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("YOU LOSE!")
	elif body.is_in_group("Destructable"):
		print("BOOM")
		body.queue_free()
