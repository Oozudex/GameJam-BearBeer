extends Area2D

@export var temp_gain: int = 10

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_temp"):
		body.add_temp(temp_gain)
	queue_free()
